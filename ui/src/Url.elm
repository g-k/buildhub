module Url exposing (routeFromFilters, routeFromUrl, urlFromRoute)

import Navigation exposing (..)
import Types exposing (..)
import UrlParser exposing (..)


routeFromUrl : Model -> Location -> Model
routeFromUrl model location =
    let
        route =
            parseHash
                (oneOf
                    [ map DocsView (s "docs" </> top)
                    , map MainView (s "builds" </> top)
                    , map ProductView
                        (s "builds"
                            </> (s "product" </> string)
                        )
                    , map ChannelView
                        (s "builds"
                            </> (s "product" </> string)
                            </> (s "channel" </> string)
                        )
                    , map PlatformView
                        (s "builds"
                            </> (s "product" </> string)
                            </> (s "channel" </> string)
                            </> (s "platform" </> string)
                        )
                    , map VersionView
                        (s "builds"
                            </> (s "product" </> string)
                            </> (s "channel" </> string)
                            </> (s "platform" </> string)
                            </> (s "version" </> string)
                        )
                    , map LocaleView
                        (s "builds"
                            </> (s "product" </> string)
                            </> (s "channel" </> string)
                            </> (s "platform" </> string)
                            </> (s "version" </> string)
                            </> (s "locale" </> string)
                        )
                    , map BuildIdView
                        (s "builds"
                            </> (s "product" </> string)
                            </> (s "channel" </> string)
                            </> (s "platform" </> string)
                            </> (s "version" </> string)
                            </> (s "locale" </> string)
                            </> (s "buildId" </> string)
                        )
                    ]
                )
                location
    in
        case route of
            Just DocsView ->
                { model | route = DocsView }

            Just (BuildIdView product channel platform version locale buildId) ->
                { model
                    | route = BuildIdView product channel platform version locale buildId
                    , buildIdFilter = buildId
                    , productFilter = product
                    , channelFilter = channel
                    , platformFilter = platform
                    , versionFilter = version
                    , localeFilter = locale
                }

            Just (ProductView product) ->
                { model
                    | route = ProductView product
                    , buildIdFilter = ""
                    , productFilter = product
                    , channelFilter = "all"
                    , platformFilter = "all"
                    , versionFilter = "all"
                    , localeFilter = "all"
                }

            Just (ChannelView product channel) ->
                { model
                    | route = ChannelView product channel
                    , buildIdFilter = ""
                    , productFilter = product
                    , channelFilter = channel
                    , platformFilter = "all"
                    , versionFilter = "all"
                    , localeFilter = "all"
                }

            Just (PlatformView product channel platform) ->
                { model
                    | route = PlatformView product channel platform
                    , buildIdFilter = ""
                    , productFilter = product
                    , channelFilter = channel
                    , platformFilter = platform
                    , versionFilter = "all"
                    , localeFilter = "all"
                }

            Just (VersionView product channel platform version) ->
                { model
                    | route = VersionView product channel platform version
                    , buildIdFilter = ""
                    , productFilter = product
                    , channelFilter = channel
                    , platformFilter = platform
                    , versionFilter = version
                    , localeFilter = "all"
                }

            Just (LocaleView product channel platform version locale) ->
                { model
                    | route = VersionView product channel platform version
                    , buildIdFilter = ""
                    , productFilter = product
                    , channelFilter = channel
                    , platformFilter = platform
                    , versionFilter = version
                    , localeFilter = locale
                }

            _ ->
                { model
                    | route = MainView
                    , buildIdFilter = ""
                    , productFilter = "all"
                    , channelFilter = "all"
                    , platformFilter = "all"
                    , versionFilter = "all"
                    , localeFilter = "all"
                }


urlFromRoute : Route -> String
urlFromRoute route =
    case route of
        DocsView ->
            "#/docs/"

        ProductView product ->
            "#/builds/product/" ++ product

        ChannelView product channel ->
            "#/builds/product/"
                ++ product
                ++ "/channel/"
                ++ channel

        PlatformView product channel platform ->
            "#/builds/product/"
                ++ product
                ++ "/channel/"
                ++ channel
                ++ "/platform/"
                ++ platform

        VersionView product channel platform version ->
            "#/builds/product/"
                ++ product
                ++ "/channel/"
                ++ channel
                ++ "/platform/"
                ++ platform
                ++ "/version/"
                ++ version

        LocaleView product channel platform version locale ->
            "#/builds/product/"
                ++ product
                ++ "/channel/"
                ++ channel
                ++ "/platform/"
                ++ platform
                ++ "/version/"
                ++ version
                ++ "/locale/"
                ++ locale

        BuildIdView product channel platform version locale buildId ->
            "#/builds/product/"
                ++ product
                ++ "/channel/"
                ++ channel
                ++ "/platform/"
                ++ platform
                ++ "/version/"
                ++ version
                ++ "/locale/"
                ++ locale
                ++ "/buildId/"
                ++ buildId

        _ ->
            "#/builds/"


routeFromFilters : Model -> Route
routeFromFilters { buildIdFilter, localeFilter, versionFilter, platformFilter, channelFilter, productFilter } =
    if buildIdFilter /= "" then
        BuildIdView productFilter channelFilter platformFilter versionFilter localeFilter buildIdFilter
    else if localeFilter /= "all" then
        LocaleView productFilter channelFilter platformFilter versionFilter localeFilter
    else if versionFilter /= "all" then
        VersionView productFilter channelFilter platformFilter versionFilter
    else if platformFilter /= "all" then
        PlatformView productFilter channelFilter platformFilter
    else if channelFilter /= "all" then
        ChannelView productFilter channelFilter
    else if productFilter /= "all" then
        ProductView productFilter
    else
        MainView