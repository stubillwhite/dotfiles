"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileOpen = void 0;
const vscode = require("vscode");
class FileOpen {
    static async openText(json) {
        const untitledDoc = await vscode.workspace.openTextDocument({
            language: 'json',
            content: json,
        });
        return untitledDoc;
    }
    static async showKeybindingsJson(untitledDoc) {
        const fullRange = new vscode.Range(untitledDoc.lineAt(0).range.start, untitledDoc.lineAt(untitledDoc.lineCount - 1).range.end);
        await vscode.window.showTextDocument(untitledDoc, { selection: fullRange });
        await vscode.commands.executeCommand('workbench.action.newGroupRight');
        await vscode.commands.executeCommand('workbench.action.openGlobalKeybindingsFile');
        await vscode.window.showInformationMessage('Please copy & paste it into keybindings.json');
    }
}
exports.FileOpen = FileOpen;
//# sourceMappingURL=FileOpen.js.map