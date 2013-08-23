' *********************************************************
' **  Roku Registration Demonstration App
' **  Support routines
' **  May 2009
' **  Copyright (c) 2009 Roku Inc. All Rights Reserved.
' *********************************************************

'***************************************************
'** Set up the screen in advance before its shown
'** Do any pre-display setup work here
'***************************************************
Function preShowHomeScreen(breadA=invalid, breadB=invalid) As Object
    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    screen.SetListStyle("arced-landscape")
    return screen
End Function

'********************************************************************
'** Show the home screen with a few static entries for illustration
'********************************************************************
Function showHomeScreen(screen) As Integer

    if type(screen)<>"roPosterScreen" then
        print "illegal type/value for screen passed to showHomeScreen"
        return -1
    end if

    itemNames = getItemNames()
    screen.SetContentList(itemNames)
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())

        if type(msg) = "roPosterScreenEvent" then
            print "showHomeScreen | msg = " +  msg.GetMessage() + " | index = " + itostr(msg.GetIndex())

            if msg.isListItemSelected() then
                displayVideo("")
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while

End Function

'**********************************************************************
'** These are the items on the home screen, they do nothing and are
'** are included so that the home screen has some content to select.
'** Press and item and you should get the registration screen displayed
'***********************************************************************
Function getItemNames() As Object
    ' We should return a thing here and stuff
    items = [ "Avatar", "Avatar 2", "Avatar 3", "Avatar 4" ]
    return items
End Function

'*************************************************************
'** displayVideo()
'*************************************************************

Function displayVideo(args As Dynamic)
    print "Displaying video: "
    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)

    'bitrates  = [0]          ' 0 = no dots, adaptive bitrate
    'bitrates  = [348]    ' <500 Kbps = 1 dot
    'bitrates  = [664]    ' <800 Kbps = 2 dots
    'bitrates  = [996]    ' <1.1Mbps  = 3 dots
    'bitrates  = [2048]    ' >=1.1Mbps = 4 dots
    bitrates  = [0]

    ' Big Buck Bunny test stream from Wowza
    urls = ["http://put.io/v2/files/102376493/stream?token=0b10c474bf0d11e29a0b00237d9c6b49"]
    qualities = ["SD"]
    streamformat = "mp4"
    title = "Big Buck Bunny"

    if type(args) = "roAssociativeArray"
        if type(args.url) = "roString" and args.url <> "" then
            urls[0] = args.url
        end if
        if type(args.StreamFormat) = "roString" and args.StreamFormat <> "" then
            StreamFormat = args.StreamFormat
        end if
        if type(args.title) = "roString" and args.title <> "" then
            title = args.title
        else
            title = ""
        end if
        if type(args.srt) = "roString" and args.srt <> "" then
            'srt = args.StreamFormat
        else
            'srt = ""
        end if
    end if

    videoclip = CreateObject("roAssociativeArray")
    videoclip.StreamBitrates = bitrates
    videoclip.StreamUrls = urls
    videoclip.StreamQualities = qualities
    videoclip.StreamFormat = StreamFormat
    videoclip.Title = title
    'print "srt = ";srt
    'if srt <> invalid and srt <> "" then
    ''    videoclip.SubtitleUrl = srt
    'end if

    video.SetContent(videoclip)
    video.show()

    lastSavedPos   = 0
    statusInterval = 10 'position must change by more than this number of seconds before saving

    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                print "Closing video screen"
                exit while
            else if msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
                if nowpos > 10000

                end if
                if nowpos > 0
                    if abs(nowpos - lastSavedPos) > statusInterval
                        lastSavedPos = nowpos
                    end if
                end if
            else if msg.isRequestFailed()
                print "play failed: "; msg.GetMessage()
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while
End Function
