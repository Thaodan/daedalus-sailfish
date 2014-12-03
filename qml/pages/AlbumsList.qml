import QtQuick 2.0
import Sailfish.Silica 1.0
//import harbour.smpc.components 1.0
import "../components"

Page {
    id: albumslistPage
    allowedOrientations: bothOrientation
    property string artistname
    property string artisturn;
    property int lastIndex
    property int lastOrientation
    property int oldCount
    Loader {
        id: gridViewLoader
        active: false
        anchors.fill: albumslistPage

        //        anchors.bottomMargin: quickControlPanel.visibleSize
        sourceComponent: Component {
            SilicaGridView {
                id: albumGridView
                clip: true
                model: albumsModel
                cellWidth: width / 2
                cellHeight: cellWidth
                SectionScroller {
                    id: sectionScroller
                    gridView: albumGridView
                    landscape: false
                    sectionPropertyName: "sectionprop"
                }
                populate: Transition {
                    NumberAnimation {
                        properties: "x"
                        from: albumGridView.width * 2
                        duration: populateDuration
                    }
                }
                ScrollDecorator {
                }

                quickScrollEnabled: jollaQuickscroll
                header: PageHeader {
                    title: artistname !== "" ? artistname : qsTr("albums")
                    width: parent.width
                    height: Theme.itemSizeMedium
                }
                PullDownMenu {
                    enabled: artistname !== ""
                    MenuItem {
                        text: qsTr("add albums")
                        onClicked: {
                            addArtist(artisturn)
                        }
                    }
                    MenuItem {
                        text: qsTr("play albums")
                        onClicked: {
                            playArtist(artisturn)
                        }
                    }
                }
                delegate: AlbumDelegate {
                }
                onCountChanged: {
                    if (oldCount != count ) {
                        console.debug("Gridview count changed: " + count);
                        oldCount = count;
                        sectionScroller.rereadSections();
                    }
                }
            }
        }
    }

    Loader {
        id: listviewLoader
        active: false
        anchors.fill: albumslistPage

        //        anchors.bottomMargin: quickControlPanel.visibleSize
        sourceComponent: Component {
            SilicaListView {
                id: listView
                clip: true
                model: albumsModel
                quickScrollEnabled: jollaQuickscroll
                SectionScroller {
                    id: sectionScroller
                    listview: listView
                    landscape: false
                    sectionPropertyName: "sectionprop"
                }
                populate: Transition {
                    NumberAnimation {
                        properties: "x"
                        from: listView.width * 2
                        duration: populateDuration
                    }
                }
                ScrollDecorator {
                }

                header: PageHeader {
                    title: artistname !== "" ? artistname : qsTr("albums")
                    width: parent.width
                    height: Theme.itemSizeMedium
                }
                PullDownMenu {
                    enabled: artistname !== ""
                    MenuItem {
                        text: qsTr("add albums")
                        onClicked: {
                            addArtist(artisturn)
                        }
                    }
                    MenuItem {
                        text: qsTr("play albums")
                        onClicked: {
                            playArtist(artisturn)
                        }
                    }
                }
                delegate: AlbumListDelegate {
                }
                section {
                    property: 'sectionprop'
                    delegate: SectionHeader {
                        text: section
                    }
                }
                onCountChanged: {
                    if (oldCount != count ) {
                        console.debug("Gridview count changed: " + count);
                        oldCount = count;
                        sectionScroller.rereadSections();
                    }
                }
            }
        }
    }

    Loader {
        id: showViewLoader
        active: false
        anchors.fill: parent
        //        anchors.rightMargin: quickControlPanel.visibleSize
        sourceComponent: Component {
            PathView {
                id: showView
                property int itemHeight: height / (1.3)
                property int itemWidth: itemHeight
                model: albumsModel

                SectionScroller {
                    id: sectionScroller
                    pathview: showView
                    landscape: true
                    sectionPropertyName: "sectionprop"
                    z: 120
                    interactive: showView.interactive
                }

                cacheItemCount: pathItemCount + 2
                pathItemCount: 12 // width/itemWidth
                delegate: AlbumShowDelegate {
                }
                snapMode: PathView.NoSnap

                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                clip: true
                path: Path {
                    startX: 0
                    startY: showView.height / 2
                    // Left out
                    PathAttribute {
                        name: "z"
                        value: 0
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 80
                    }

                    // Left flip (bottom)
                    PathLine {
                        x: (showView.width / 2) - (showView.itemWidth / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 50
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 70
                    }
                    PathPercent {
                        value: 0.45
                    }

                    // Center (bottom)
                    PathLine {
                        x: (showView.width / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 100
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 0
                    }
                    PathPercent {
                        value: 0.5
                    }

                    // Right Flip (bottom)
                    PathLine {
                        x: (showView.width / 2) + (showView.itemWidth / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 50
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: -70
                    }
                    PathPercent {
                        value: 0.55
                    }

                    // Right out
                    PathLine {
                        x: showView.width
                        y: showView.height / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 0
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: -80
                    }
                    PathPercent {
                        value: 1.0
                    }
                }

                onCountChanged: {
                    if (oldCount != count ) {
                        console.debug("Gridview count changed: " + count);
                        oldCount = count;
                        sectionScroller.rereadSections();
                    }
                }
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (!orientationTransitionRunning
                    && orientation != lastOrientation) {
                gridViewLoader.active = false
                listviewLoader.active = false
                showViewLoader.active = false
                if ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) {
                    console.debug("activating page with portrait grid view")
                    if (albumView === 0) {
                        gridViewLoader.active = true
                    } else if (albumView === 1) {
                        listviewLoader.active = true
                    }
                } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) {
                    console.debug("activating page landscape showview")
                    showViewLoader.active = true
                }
            }
        }
        if (status === PageStatus.Deactivating) {
            lastOrientation = orientation
        }

        if (status === PageStatus.Deactivating
                && typeof (gridViewLoader.item) != undefined
                && gridViewLoader.item) {
            lastIndex = gridViewLoader.item.currentIndex
        } else if (status === PageStatus.Activating) {
            if (typeof (gridViewLoader.item) != undefined
                    && gridViewLoader.item) {
                gridViewLoader.item.positionViewAtIndex(lastIndex,
                                                        GridView.Center)
            }
            requestArtistInfo(artistname)
        } else if (status === PageStatus.Active) {
            if (artistname != "")
                pageStack.pushAttached(Qt.resolvedUrl("ArtistInfoPage.qml"), {
                                           artistname: artistname
                                       })
        }
    }

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            if ( (orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted) ){
                console.debug("activating portrait grid view")
                if (albumView === 0) {
                    gridViewLoader.active = true
                } else if (albumView === 1) {
                    listviewLoader.active = true
                }
            } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted) ) {
                console.debug("activating landscape showview")
                showViewLoader.active = true
            }
        } else {
            console.debug("deactivating loaders")
            gridViewLoader.active = false
            listviewLoader.active = false
            showViewLoader.active = false
            // Deactivating components
        }
    }

    Component.onDestruction: {
        clearAlbumList()
    }
}
