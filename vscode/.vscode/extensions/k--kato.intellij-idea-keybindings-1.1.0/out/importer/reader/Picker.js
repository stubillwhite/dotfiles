"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Picker = void 0;
const vscode = require("vscode");
const OS_1 = require("../model/OS");
class Picker {
    static async pickOSDestionation() {
        const osOptions = {
            placeHolder: 'Which OS do you want to convert for?',
            ignoreFocusOut: true,
        };
        const picked = await vscode.window.showQuickPick(OS_1.OSPickerList, osOptions);
        switch (picked) {
            case OS_1.MAC_TO_LINUX:
                return { src: 'Mac', dst: 'Linux' };
            case OS_1.MAC_TO_MAC:
                return { src: 'Mac', dst: 'Mac' };
            case OS_1.MAC_TO_WINDOWS:
                return { src: 'Mac', dst: 'Windows' };
            case OS_1.WINDOWS_TO_LINUX:
                return { src: 'Windows', dst: 'Linux' };
            case OS_1.WINDOWS_TO_MAC:
                return { src: 'Windows', dst: 'Mac' };
            case OS_1.WINDOWS_TO_WINDOWS:
                return { src: 'Windows', dst: 'Windows' };
            case undefined:
                return undefined;
        }
    }
}
exports.Picker = Picker;
//# sourceMappingURL=Picker.js.map