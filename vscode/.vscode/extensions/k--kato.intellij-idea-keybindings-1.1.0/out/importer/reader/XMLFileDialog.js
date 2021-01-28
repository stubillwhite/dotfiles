"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OSDestinationPicker = void 0;
const vscode = require("vscode");
const OS_1 = require("../model/OS");
class OSDestinationPicker {
    static async pick() {
        const osOptions = {
            placeHolder: 'Which OS do you want to convert for?',
            ignoreFocusOut: true,
        };
        const osDestination = (await vscode.window.showQuickPick(OS_1.OSArray.map(os => os), osOptions));
        return osDestination;
    }
}
exports.OSDestinationPicker = OSDestinationPicker;
//# sourceMappingURL=XMLFileDialog.js.map