import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: currentsong_page
    //property int lengthtextcurrent:lengthTextcurrent.text;
    property int fontsize: Theme.fontSizeMedium
    property int fontsizegrey: Theme.fontSizeSmall
    property bool detailsvisible: true
    property bool pageactive: false

    Component.onDestruction: {
        mCurrentSongPage = null
    }

    allowedOrientations: bothOrientation

    Drawer {
        id: mainDrawer
        dock: (orientation === Orientation.Portrait
               || orientation === Orientation.PortraitInverted) ? Dock.Bottom : Dock.Right
        anchors.fill: parent
        open: true

        SilicaFlickable {
            id: infoFlickable
            anchors.fill: parent
            BackgroundItem {
                id: drawerOpenBackgroundItem
                anchors.fill: parent
                onClicked: {
                    if (currentsong_page.state == "landscape"
                            && mainDrawer.open) {
                        mainDrawer.hide()
                    } else if (currentsong_page.state == "landscape"
                               && !mainDrawer.open) {
                        mainDrawer.show()
                        //                        volumeControl.state = "slideVisible"
                        drawerCloseTimer.start()
                    }
                }
            }
            PullDownMenu {
                MenuItem {
                    text: qsTr("show all tracks from album")
                    visible: playbackstatus.album === "" ? false : true
                    onClicked: {
                        requestTrackAlbumTracks(playbackstatus.trackurn);
                        pageStack.push(Qt.resolvedUrl("AlbumTracks.qml"), {
                                           artistname: playbackstatus.artist,
                                           albumname: playbackstatus.album
                                       });
                    }
                }
                MenuItem {
                    text: qsTr("show albums from artist")
                    visible: playbackstatus.artist === "" ? false : true
                    onClicked: {
                        requestTrackArtistAlbums(playbackstatus.trackurn);
                        pageStack.push(Qt.resolvedUrl("AlbumsList.qml"), {
                                           artistname: playbackstatus.artist,
                                       });
                    }
                }
            }
            contentHeight: contentColumn.height
            clip: true
            Column {
                id: contentColumn

                clip: true
                anchors {
                    right: parent.right
                    left: parent.left
                }

                PageHeader {
                    id: pageHeading
                    title: qsTr("current song")
                }
                // Spacing hack
                Rectangle {
                    opacity: 0.0
                    // Center landscapeimages
                    height: (currentsong_page.height - landscapeImageRow.height) / 2
                    width: parent.width
                    visible: landscapeImageRow.visible
                }

                Column {
                    id: subColumn
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: listPadding
                        rightMargin: listPadding
                    }

                    ToggleImage {
                        enabled: showCoverNowPlaying
                        visible: showCoverNowPlaying
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                        id: coverImage
                        property int calcheight: (infoFlickable.height
                                                  - (titleText.height + albumText.height
                                                     + artistText.height + pageHeading.height))
                        height: showCoverNowPlaying ? (calcheight > (contentColumn.width - listPadding * 2) ? (contentColumn.width - listPadding * 2) : calcheight) : 0
                        width: height
                        fillMode: Image.PreserveAspectFit
                        sourceprimary: coverimageurl
                        sourcesecondary: artistimageurl
                        active: visible
                        Image {
                            id: fallbackImage
                            enabled: showCoverNowPlaying
                            source: "qrc:/images/smpc-big.png"
                            anchors.fill: parent
                            visible: (!coverImage.ready && showCoverNowPlaying)
                        }
                    }
                    Item {
                        id: landscapeImageRow
                        width: parent.width
                        height: albumImgLandscape.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        Image {
                            id: albumImgLandscape
                            source: coverimageurl
                            width: (parent.width / 2)
                            height: width
                            anchors {
                                top: parent.top
                                left: parent.left
                            }
                            cache: false
                            fillMode: Image.PreserveAspectCrop
                        }
                        Image {
                            id: artistImgLandscape
                            source: artistimageurl
                            width: (parent.width / 2)
                            height: width
                            anchors {
                                top: parent.top
                                left: albumImgLandscape.right
                                leftMargin: Theme.paddingSmall
                            }
                            cache: false
                            fillMode: Image.PreserveAspectCrop
                        }
                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.5
                                    color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
                                }
                                GradientStop {
                                    position: 0.7
                                    color: Qt.rgba(0.0, 0.0, 0.0, 0.3)
                                }
                                GradientStop {
                                    position: 1.0
                                    color: Qt.rgba(0.0, 0.0, 0.0, 1.0)
                                }
                            }
                        }

                        Column {
                            id: landscapeTextScrollColumn
                            anchors {
                                bottom: parent.bottom
                            }
                            width: landscapeImageRow.width

                            ScrollLabel {
                                id: titleTextLC
                                text: playbackstatus.title
                                color: Theme.primaryColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: albumTextLC
                                text: playbackstatus.album
                                color: Theme.primaryColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: artistTextLC
                                text: playbackstatus.artist
                                color: Theme.primaryColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                        }
                    }
                    // Spacing hack
                    Rectangle {
                        opacity: 0.0
                        // Center landscapeimages
                        height: (currentsong_page.height - landscapeImageRow.height) / 2
                        width: parent.width
                        visible: landscapeImageRow.visible
                    }

                    ScrollLabel {
                        id: titleText
                        text: playbackstatus.title
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                    ScrollLabel {
                        id: albumText
                        text: playbackstatus.album
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                    ScrollLabel {
                        id: artistText
                        text: playbackstatus.artist
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Label {
                        text: qsTr("track no.:")
                        color: Theme.secondaryColor
                        font.pixelSize: fontsizegrey
                        anchors {
                            left: parent.left
                        }
                    }
                    Label {
                        id: nrText
                        text: playbackstatus.tracknr
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WordWrap"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr("playlist no.:")
                        color: Theme.secondaryColor
                        font.pixelSize: fontsizegrey
                        anchors {
                            left: parent.left
                        }
                    }
                    Label {
                        id: playlistnrText
                        text: (playbackstatus.playlistposition + 1) + " / "
                              + playbackstatus.playlistlength
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WordWrap"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: qsTr("bitrate:")
                        color: Theme.secondaryColor
                        font.pixelSize: fontsizegrey
                    }
                    Label {
                        id: bitrateText
                        text: "FIXME"
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WordWrap"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        text: qsTr("properties:")
                        color: Theme.secondaryColor
                        font.pixelSize: fontsizegrey
                    }
                    Label {
                        id: audiopropertiesText
                        text: "FIXME"
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WordWrap"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        text: qsTr("uri:")
                        color: Theme.secondaryColor
                        font.pixelSize: fontsizegrey
                    }
                    Label {
                        id: fileText
                        text: playbackstatus.url
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WrapAnywhere"

                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                }
            }
        }

        backgroundSize: positionSlider.height + buttonRow.height
        background: Column {
            id: backgroundColumn
            anchors.fill: parent
            /*
            Item {
                id: volumeControl
                width: parent.width
                height: volumeSlider.height
                state: "sliderInvisible"
                states: [
                    State {
                        name: "sliderVisible"
                        PropertyChanges {
                            target: volumeSlider
                            enabled: true
                            opacity: 1.0
                        }
                        PropertyChanges {
                            target: volumeButton
                            enabled: false
                            opacity: 0.0
                        }
                    },
                    State {
                        name: "sliderInvisible"
                        PropertyChanges {
                            target: volumeSlider
                            enabled: false
                            opacity: 0.0
                        }
                        PropertyChanges {
                            target: volumeButton
                            enabled: true
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        NumberAnimation {
                            properties: "opacity"
                            duration: 500
                        }
                    }
                ]

                IconButton {
                    id: volumeButton
                    anchors.centerIn: parent
                    icon.source: "image://theme/icon-status-volume-max"
                    onClicked: {
                        volumeControl.state = "sliderVisible"
                        volumeSliderFadeOutTimer.start()
                    }
                }

                Slider {
                    anchors.fill: parent

                    id: volumeSlider
                    stepSize: 1
                    maximumValue: 100
                    minimumValue: 0
                    value: mVolume
                    valueText: value + "%"
                    label: qsTr("volume")
                    onPressedChanged: {
                        if (!pressed) {
                            volumeChanging = false
                            setVolume(value)
                            mVolume = value
                            value = Qt.binding(function () {
                                return mVolume
                            })
                            volumeControl.state = "sliderInvisible"
                        } else {
                            volumeChanging = true
                            volumeSliderFadeOutTimer.stop()
                        }
                    }
                    onValueChanged: {
                        if (pressed)
                            setVolume(value)
                        // valueText = value+"%";
                    }
                }

                Timer {
                    id: volumeSliderFadeOutTimer
                    interval: 3000
                    repeat: false
                    onTriggered: {
                        volumeControl.state = "sliderInvisible"
                    }
                }
            }*/

            Slider {
                id: positionSlider
                width: parent.width
                stepSize: 1.0
                maximumValue: (playbackstatus.length > 0) ? playbackstatus.length : 1.0
                minimumValue: 0.0
                value: playbackstatus.elapsed
                valueText: formatLength(value)
                label: qsTr("position")
                Label {
                    id: lengthTextcomplete
                    text: playbackstatus.lengthformatted
                    color: Theme.primaryColor
                    font.pixelSize: fontsizegrey
                    wrapMode: "WordWrap"
                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingLarge
                        bottom: parent.bottom
                    }
                }
                onPressedChanged: {
                    mPositionSliderActive = pressed
                    if (!pressed) {
                        seek(value)
                        value = Qt.binding(function () {
                            return playbackstatus.elapsed
                        })
                    } else {
                        console.debug("Slider pressed")
                        value = playbackstatus.elapsed
                    }
                }
            }
            Row {
                id: buttonRow
                anchors.horizontalCenter: parent.horizontalCenter
                height: shuffleButton.height
                Switch {
                    id: shuffleButton
                    icon.source: "image://theme/icon-m-shuffle"
                    checked: playbackstatus.shuffle
                    onClicked: {
                        setShuffle(checked);
                        checked  = Qt.binding(function() {return playbackstatus.random;});
                    }
                }
                IconButton {
                    id: prevButton
                    icon.source: "image://theme/icon-m-previous"
                    onClicked: prev()
                }
                IconButton {
                    id: stopButton
                    icon.source: "qrc:images/icon-m-stop.png"
                    onClicked: stop()
                }
                IconButton {
                    id: playButton
                    icon.source: playbuttoniconsource
                    onClicked: togglePlayPause()
                }
                IconButton {
                    id: nextButton
                    icon.source: "image://theme/icon-m-next"
                    onClicked: next()
                }
                Switch {
                    id: repeatButton
                    checked: playbackstatus.repeat
                    icon.source: "image://theme/icon-m-repeat"
                    onClicked: {
                        setRepeat(checked)
                        checked  = Qt.binding(function() {return playbackstatus.repeat;});
                    }
                }
            }
        }
    }

    onStatusChanged: {
        if ((status === PageStatus.Activating)
                || (status === PageStatus.Active)) {
            pageactive = true
            //            positionSlider.handleVisible = false;
            //            positionSlider.handleVisible = true;
            //            positionSlider.valueText = Qt.binding(function () {return formatLength(positionSlider.value);})
            quickControlPanel.hideControl = true
        } else {
            quickControlPanel.hideControl = false
            pageactive = false
        }
    }

    states: [
        State {
            name: "portrait"
            PropertyChanges {
                target: coverImage
                visible: true
            }
            PropertyChanges {
                target: titleText
                visible: true
            }
            PropertyChanges {
                target: artistText
                visible: true
            }
            PropertyChanges {
                target: albumText
                visible: true
            }
            PropertyChanges {
                target: mainDrawer
                open: true
            }
            PropertyChanges {
                target: pageHeading
                visible: true
            }
            PropertyChanges {
                target: landscapeImageRow
                visible: false
            }
            PropertyChanges {
                target: drawerCloseTimer
                running: false
            }
            PropertyChanges {
                target: drawerOpenBackgroundItem
                enabled: false
            }
            PropertyChanges {
                target: shuffleButton
                visible: true
            }
            PropertyChanges {
                target: repeatButton
                visible: true
            }
        },
        State {
            name: "landscape"
            PropertyChanges {
                target: coverImage
                visible: false
            }
            PropertyChanges {
                target: titleText
                visible: false
            }
            PropertyChanges {
                target: artistText
                visible: false
            }
            PropertyChanges {
                target: albumText
                visible: false
            }
            PropertyChanges {
                target: mainDrawer
                open: false
            }
            PropertyChanges {
                target: pageHeading
                visible: false
            }
            PropertyChanges {
                target: landscapeImageRow
                visible: true
            }
            PropertyChanges {
                target: drawerOpenBackgroundItem
                enabled: true
            }
            PropertyChanges {
                target: shuffleButton
                visible: false
            }
            PropertyChanges {
                target: repeatButton
                visible: false
            }
        }
    ]
    state: ((orientation === Orientation.Portrait)
            || (orientation === Orientation.PortraitInverted)) ? "portrait" : "landscape"

    Timer {
        id: drawerCloseTimer
        interval: 5000
        repeat: false
        onTriggered: {
            mainDrawer.hide()
        }
    }
}
