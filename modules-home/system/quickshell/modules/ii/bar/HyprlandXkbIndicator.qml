import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property bool vertical: false
    property color color: Appearance.colors.colOnSurfaceVariant
    implicitWidth: layoutCodeText.implicitWidth
    implicitHeight: layoutCodeText.implicitHeight

    function abbreviateLayoutCode(fullCode) {
        if (!fullCode || fullCode.length === 0) return "??";
        return fullCode.split(':').map(layout => {
            const baseLayout = layout.split('-')[0];
            return baseLayout.slice(0, 4);
        }).join('\n');
    }

    StyledText {
        id: layoutCodeText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: abbreviateLayoutCode(HyprlandXkb.currentLayoutCode)
        font.pixelSize: Appearance.font.pixelSize.small
        color: root.color
        animateChange: true
    }
}
