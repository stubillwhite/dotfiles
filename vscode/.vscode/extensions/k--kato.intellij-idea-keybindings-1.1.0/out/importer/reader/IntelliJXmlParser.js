"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.IntelliJXmlParser = void 0;
const parser = require("fast-xml-parser");
const IntelliJKeymapXml_1 = require("../model/intellij/implement/IntelliJKeymapXml");
class IntelliJXmlParser {
    static parseToJSON(xml) {
        const parserXmlOptions = {
            ignoreAttributes: false,
            parseAttributeValue: true,
            arrayMode: true,
        };
        if (!parser.validate(xml)) {
            throw Error('Cannot load this IntelliJ IDEA Keymap file. Plesase check the file format.');
        }
        return parser.parse(xml, parserXmlOptions);
    }
    static desirialize(json) {
        if (!json.keymap) {
            throw Error('Cannot find any IntelliJ IDEA Keymap settings in this file. Make sure that the file is an XML file exported from IntelliJ Idea.');
        }
        const intellijKeymaps = new Array();
        const actionElements = json.keymap[0].action;
        for (const actionIndex in actionElements) {
            const actionIdAttr = actionElements[actionIndex]['@_id'];
            const keystorkeElements = actionElements[actionIndex]['keyboard-shortcut'];
            for (const keystrokeIndex in keystorkeElements) {
                const keyboardShortcutElement = keystorkeElements[keystrokeIndex];
                const firstKeystrokeAttr = keyboardShortcutElement['@_first-keystroke'];
                const secondKeystrokeAttr = keyboardShortcutElement['@_second-keystroke'];
                const intellijKeymapXml = new IntelliJKeymapXml_1.IntelliJKeymapXml(actionIdAttr, firstKeystrokeAttr, secondKeystrokeAttr);
                intellijKeymaps.push(intellijKeymapXml);
            }
        }
        return intellijKeymaps;
    }
}
exports.IntelliJXmlParser = IntelliJXmlParser;
//# sourceMappingURL=IntelliJXmlParser.js.map