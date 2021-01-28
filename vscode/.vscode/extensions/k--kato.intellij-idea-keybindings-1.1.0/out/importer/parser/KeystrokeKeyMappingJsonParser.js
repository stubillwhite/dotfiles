"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.KeystrokeKeyMappingJsonParser = void 0;
const KeystrokeKeyMapping_1 = require("../model/resource/KeystrokeKeyMapping");
class KeystrokeKeyMappingJsonParser {
    static async desirialize(json) {
        if (!json) {
            return [];
        }
        const keystrokeKeyMappings = new Array();
        const jsonObj = JSON.parse(json);
        for (let i = 0; i < jsonObj.length; i++) {
            const row = jsonObj[i];
            const keystrokeKeyMapping = new KeystrokeKeyMapping_1.KeystrokeKeyMapping(row.intellij, row.vscode);
            keystrokeKeyMappings.push(keystrokeKeyMapping);
        }
        return keystrokeKeyMappings;
    }
}
exports.KeystrokeKeyMappingJsonParser = KeystrokeKeyMappingJsonParser;
//# sourceMappingURL=KeystrokeKeyMappingJsonParser.js.map