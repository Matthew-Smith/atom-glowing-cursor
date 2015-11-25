/*global atom*/
import {Disposable, CompositeDisposable} from 'atom';

// helper functions

// get the key in namespace
function getConfig(key, namespace = 'glowing-cursor') {
    return atom.config.get(key ? `${namespace}.${key}` : namespace);
}

// set the key in namespace
function setConfig(key, value, namespace = 'glowing-cursor') {
    return atom.config.set(`${namespace}.${key}`, value);
}

// convert a color to a string
function toRGBAString(color) {
    if (typeof color === 'string') {
        return color;
    }
    if (typeof color.toRGBAString === 'function') {
        return color.toRGBAString();
    }
    return `rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})`;
}

// private API

// keep a reference to the stylesheet
var style;

// create a stylesheet element and
// attach it to the DOM
function setupStylesheet() {
    style = document.createElement('style');
    style.type = 'text/css';
    document.querySelector('head atom-styles').appendChild(style);

    // return a disposable for easy removal :)
    return new Disposable(() => {
        style.parentNode.removeChild(style);
        style = null;
    });
}

function updateCursorStyles() {
    style.innerHTML = '';
    var glowColor = toRGBAString(getConfig('global.glowColor'));
    var innerColor = toRGBAString(getConfig('global.innerColor'));
    var cursorWidth = getConfig('global.cursorWidth');

    var pulseOnRule = createCSSRule({
        selector: '.pulse-on',
        properties: {
            transition: 'opacity 500ms ease-in-out',
            opacity: 1,
            'border-color': `${innerColor}`,
            'border-width': `0 0 0 ${cursorWidth}px`
        }
    });
    var pulseOffRule = createCSSRule({
        selector: '.pulse-off',
        properties: {
            opacity: 0,
            visibility: 'visible !important'
        }
    });
    var cursorRule = createCSSRule({
        selector: '.cursor',
        properties: {
            width: `${cursorWidth}px !important`,
            'box-shadow': `0px 0px 6px 0px ${glowColor}`
        }
    });
    var animationRule = `:host(.is-focused) {
        .cursors {
            & > .cursor {
                .pulse-on;
            }
            &.blink-off > .cursor {
                .pulse-off;
            }
        }
    }`;

    style.innerHTML = pulseOnRule + pulseOffRule + cursorRule + animationRule;
}

// create a css rule from a selector and an
// object containint propertyNames and values
// of the form
// <selector> {
//    <propertyName1>: <value1>;
//    <propertyName2>: <value2>;
//    ...
// }

function createCSSRule({
    selector, properties
}) {
    return `${selector} { ${Object.keys(properties).map((key) => `
    $ {
        key
    }: $ {
        properties[key]
    };
    `).join('')} }`;
}

// public API

const config = {
    global: {
        cusrorWidth: {
            title: "Cursor Width",
            description: "The width of your cursor",
            type: "integer",
            default: 1
        },
        glowColor: {
            title: "Glow Color",
            description: "Change the glow color of the selector.",
            type: "color",
            default: "rgba(75,213,255,1.0)"
        },
        innerColor: {
            title: "Selector Inner Color",
            description: "The color of the inner of the selector.",
            type: "color",
            default: "rgba(97,210,255,1.0)"
        }
    }
};

var disposables;

function activate() {
    // wait for cursor-blink-interval package to activate
    // if it is loaded
    Promise.resolve(
        atom.packages.isPackageLoaded('cursor-blink-interval') &&
        atom.packages.activatePackage('cursor-blink-interval')
    ).then(function go() {
        disposables = new CompositeDisposable(
            setupStylesheet(),
            atom.config.observe('glowing-cursor', updateCursorStyles),
        );
    }).catch(error => {
        console.error(error.message);
    });
}

function deactivate() {
    disposables.dispose();
    disposables = null;
}

export {
    config, activate, deactivate
};
