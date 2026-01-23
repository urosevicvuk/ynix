import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property color color: Appearance.colors.colOnSurfaceVariant
    implicitWidth: layoutText.implicitWidth
    implicitHeight: layoutText.implicitHeight

    property string currentLayout: "??"
    property var layouts: []
    property int currentIndex: 0

    Component.onCompleted: {
        updateLayout();
    }

    function updateLayout() {
        layoutProcess.running = true;
    }

    Process {
        id: layoutProcess
        running: true
        command: ["hyprctl", "-j", "devices"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    const mainKb = data.keyboards.find(kb => kb.main === true);
                    if (mainKb) {
                        root.layouts = mainKb.layout.split(',');
                        const activeKeymap = mainKb.active_keymap.toLowerCase();

                        // Simple mapping
                        if (activeKeymap.includes("english") || activeKeymap.includes("us")) {
                            root.currentLayout = "EN";
                        } else if (activeKeymap.includes("latin")) {
                            root.currentLayout = "SR";
                        } else if (activeKeymap.includes("cyrillic") || activeKeymap.includes("serbian")) {
                            root.currentLayout = "СР";
                        } else {
                            // Fallback to first 2-3 chars of layout code
                            if (root.layouts.length > 0) {
                                root.currentLayout = root.layouts[0].substring(0, 2).toUpperCase();
                            }
                        }
                    }
                } catch (e) {
                    console.error("KeyboardLayout: Failed to parse hyprctl output:", e);
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                updateLayout();
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: updateLayout()
    }

    StyledText {
        id: layoutText
        anchors.centerIn: parent
        text: root.currentLayout
        font.pixelSize: Appearance.font.pixelSize.small
        color: root.color
        animateChange: true
    }
}
