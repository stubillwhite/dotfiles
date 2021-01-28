"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileSaveDialog = void 0;
const vscode = require("vscode");
class FileSaveDialog {
    static async saveJson(json) {
        const writerOptions = {
            filters: {
                JSON: ['json'],
            },
        };
        const writerUri = await vscode.window.showSaveDialog(writerOptions);
        if (!writerUri) {
            return;
        }
        const writeData = Buffer.from(json, 'utf8');
        await vscode.workspace.fs.writeFile(writerUri, writeData);
    }
}
exports.FileSaveDialog = FileSaveDialog;
//# sourceMappingURL=FileSaveDialog.js.map