"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeJsonParser = void 0;
const VSCodeKeybindingDefault_1 = require("../model/vscode/implement/VSCodeKeybindingDefault");
class VSCodeJsonParser {
    static desirialize(json) {
        if (!json) {
            return [];
        }
        const vscodeKeybindings = new Array();
        const jsonObj = JSON.parse(json);
        for (let i = 0; i < jsonObj.length; i++) {
            const row = jsonObj[i];
            const vscodeKeybinding = new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(row.command, row.key, row.when);
            vscodeKeybindings.push(vscodeKeybinding);
        }
        return vscodeKeybindings;
    }
}
exports.VSCodeJsonParser = VSCodeJsonParser;
//# sourceMappingURL=VSCodeJsonParser%20copy.js.map