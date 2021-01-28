"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ActionIdCommandMappingParser = void 0;
const ActionIdCommandMapping_1 = require("../model/ActionIdCommandMapping");
class ActionIdCommandMappingParser {
    static async desirialize(json) {
        if (!json) {
            return [];
        }
        const keyMappings = new Array();
        const jsonObj = JSON.parse(json);
        for (let i = 0; i < jsonObj.length; i++) {
            const row = jsonObj[i];
            const keyMapping = new ActionIdCommandMapping_1.ActionIdCommandMapping(row.intellij, row.vscode);
            keyMappings.push(keyMapping);
        }
        return keyMappings;
    }
}
exports.ActionIdCommandMappingParser = ActionIdCommandMappingParser;
//# sourceMappingURL=KeyMappingJsonParser.js.map