import QtQuick 2.0
import Sailfish.Silica 1.0
import "SpeedScroller.js" as Sections

Item {
    id: scroller
    height: parent.height
    width: (orientation === Orientation.Portrait ||  orientation === Orientation.PortraitInverted) ?  parent.width/7 : parent.width/12
    property alias scrollenabled: inputArea.enabled
    property int listviewCache
    x: parent.x+parent.width-width;
    z:1
    property ListView listview;
//    Rectangle {
//        id: testrect
//        opacity:0.5
//        anchors.fill:parent
//    }

    Rectangle {
        id: sectionScrollIndicator
        property bool listviewScrolling : ( listview && listview.flicking)
        property bool inputAreaScrolling : inputArea.pressed
        opacity: ( (listviewScrolling || inputAreaScrolling) ? 1.0 : 0.0 )
        anchors.fill:parent

        gradient: Gradient {


            GradientStop {
                position: 0.0
                color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
            }
            GradientStop {
                position: 0.5
                color: Theme.rgba(Theme.highlightBackgroundColor,0.4)
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
            }
        }
        Behavior on opacity {
                 PropertyAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 300 }
        }
    }


    onListviewChanged: {
        if(listview && listview.model) {
            listviewCache = listview.cacheBuffer
            Sections.fillSections(listview);
            listview.modelChanged.connect( function() {
                Sections.fillSections(listview);
            });
        } else if(listview) {
            listviewCache = listview.cacheBuffer
            listview.modelChanged.connect( function() {
                Sections.fillSections(listview);
            });
        }
    }

    MouseArea {
        id: inputArea
        anchors.fill:parent
        preventStealing: true
        onMouseYChanged: {
            if(pressed) {
                listviewCache = listview.cacheBuffer
                listview.cacheBuffer = -1
                var relPos = (mouseY/height)*100;
                var item = Sections.getItemPositionFromRelative(relPos);
                if(listview && listview.model) {
                    var count = (typeof listview.model.rowCount === 'undefined' ? listview.model.length : listview.model.rowCount());
                    if ( item < count )
                        listview.positionViewAtIndex(item,ListView.Beginning);
                }
            } else {
                // Restore cacheBuffer
                listview.cacheBuffer = cacheBuffer
            }
        }
    }
    function reReadSections()
    {
        if(listview && listview.model) {
            listviewCache = listview.cacheBuffer
            Sections.fillSections(listview);
            listview.modelChanged.connect( function() {
                Sections.fillSections(listview);
            });
        } else if(listview) {
            listviewCache = listview.cacheBuffer
            listview.modelChanged.connect( function() {
                Sections.fillSections(listview);
            });
        }
    }
}
