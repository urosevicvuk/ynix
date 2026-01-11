import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property color color: Appearance.colors.colOnSurfaceVariant
    implicitWidth: containerText.visible ? containerText.implicitWidth : 0
    implicitHeight: containerText.implicitHeight

    Process {
        id: dockerProcess
        running: true
        command: ["bash", "-c", "docker ps -q 2>/dev/null | wc -l"]

        stdout: SplitParser {
            onRead: data => {
                const count = parseInt(data.trim());
                containerCount = count > 0 ? count : 0;
            }
        }
    }

    Timer {
        interval: 5000 // Check every 5 seconds
        running: true
        repeat: true
        onTriggered: dockerProcess.running = true
    }

    property int containerCount: 0

    StyledText {
        id: containerText
        anchors.centerIn: parent
        visible: root.containerCount > 0
        text: " 🐋 " + root.containerCount
        font.pixelSize: Appearance.font.pixelSize.small
        color: root.color
        animateChange: true
    }
}
