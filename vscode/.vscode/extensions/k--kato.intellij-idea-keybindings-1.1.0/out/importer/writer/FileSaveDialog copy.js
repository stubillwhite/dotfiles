"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileOpen = void 0;
const vscode = require("vscode");
class FileOpen {
    static async saveJson(json) {
        return await vscode.workspace.openTextDocument({ content: json });
    }
}
exports.FileOpen = FileOpen;
//# sourceMappingURL=FileSaveDialog%20copy.js.map