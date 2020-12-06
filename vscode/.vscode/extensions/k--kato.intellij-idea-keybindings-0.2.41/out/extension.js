"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode_1 = require("vscode");
function activate(context) {
    let disposable = vscode_1.commands.registerCommand('type', args => {
        vscode_1.window.showInformationMessage(args.text);
        vscode_1.commands.executeCommand('default:type', {
            text: args.text
        });
    });
    context.subscriptions.push(disposable);
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map