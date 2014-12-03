# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-daedalus

CONFIG += sailfishapp qtsparql

QT += multimedia sql

INCLUDEPATH += src

SOURCES += \
    src/maincontroller.cpp \
    src/model/albumsmodel.cpp \
    src/model/artistsmodel.cpp \
    src/model/albumtracksmodel.cpp \
    src/mediaplayer/daedalusmediaplayer.cpp \
    src/mediaplayer/playlist.cpp \
    src/model/trackobject.cpp \
    src/model/playbackstatusobject.cpp \
    src/metadata/albuminformation.cpp \
    src/metadata/artistinformation.cpp \
    src/metadata/imagedatabase.cpp \
    src/metadata/imagedownloader.cpp \
    src/metadata/lastfmalbumprovider.cpp \
    src/metadata/lastfmartistprovider.cpp \
    src/metadata/qmlimageprovider.cpp \
    src/harbour-daedalus.cpp

OTHER_FILES += qml/harbour-daedalus.qml \
    rpm/harbour-daedalus.changes.in \
    rpm/harbour-daedalus.spec \
    rpm/harbour-daedalus.yaml \
    translations/*.ts \
    harbour-daedalus.desktop \
    qml/pages/MainPage.qml \
    qml/pages/AlbumsList.qml \
    qml/components/AlbumListDelegate.qml \
    qml/components/SectionScroller.js \
    qml/components/SpeedScroller.js \
    qml/components/AlbumDelegate.qml \
    qml/components/AlbumShowDelegate.qml \
    qml/components/SectionScroller.qml \
    qml/components/SpeedScroller.qml \
    qml/pages/ArtistsList.qml \
    qml/components/ArtistDelegate.qml \
    qml/components/ArtistListDelegate.qml \
    qml/components/ArtistShowDelegate.qml \
    qml/commonfunctions/clickHandler.js \
    qml/pages/AlbumTracks.qml \
    qml/pages/AlbumInfoPage.qml \
    qml/pages/ArtistInfoPage.qml \
    qml/pages/settings/AboutPage.qml \
    qml/pages/settings/DatabaseSettings.qml \
    qml/pages/settings/GUISettings.qml \
    qml/pages/settings/SettingsPage.qml \
    qml/pages/SongDialog.qml \
    qml/components/ScrollLabel.qml \
    qml/components/ToggleImage.qml \
    qml/pages/CurrentPlaylistPage.qml \
    qml/components/PlaylistSectionDelegate.qml \
    qml/pages/CurrentSong.qml \
    qml/components/CoverPage.qml \
    qml/components/ControlPanel.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-daedalus-de.ts

HEADERS += \
    src/maincontroller.h \
    src/model/albumsmodel.h \
    src/global.h \
    src/model/artistsmodel.h \
    src/model/albumtracksmodel.h \
    src/mediaplayer/daedalusmediaplayer.h \
    src/mediaplayer/playlist.h \
    src/model/trackobject.h \
    src/model/playbackstatusobject.h \
    src/metadata/albuminformation.h \
    src/metadata/artistinformation.h \
    src/metadata/databasestatistic.h \
    src/metadata/imagedatabase.h \
    src/metadata/imagedownloader.h \
    src/metadata/lastfmalbumprovider.h \
    src/metadata/lastfmartistprovider.h \
    src/metadata/qmlimageprovider.h \
    src/metadata/album.h

RESOURCES += \
    images.qrc
