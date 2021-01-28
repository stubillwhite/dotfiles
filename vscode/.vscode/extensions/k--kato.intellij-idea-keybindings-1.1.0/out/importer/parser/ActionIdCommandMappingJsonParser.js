"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ActionIdCommandMappingJsonParser = void 0;
const ActionIdCommandMapping_1 = require("../model/resource/ActionIdCommandMapping");
class ActionIdCommandMappingJsonParser {
    static async desirialize(json) {
        if (!json) {
            return [];
        }
        const actionIdCommandMappings = new Array();
        const jsonObj = JSON.parse(json);
        for (let i = 0; i < jsonObj.length; i++) {
            const row = jsonObj[i];
            const actionIdCommandMapping = new ActionIdCommandMapping_1.ActionIdCommandMapping(row.intellij, row.vscode);
            actionIdCommandMappings.push(actionIdCommandMapping);
        }
        return actionIdCommandMappings;
    }
}
exports.ActionIdCommandMappingJsonParser = ActionIdCommandMappingJsonParser;
//# sourceMappingURL=ActionIdCommandMappingJsonParser.js.map