$ ->
    GLOBAL_PUBLIC = 'public'

    rolled = false
    title = ''
    isFocused = true
    isNew = false
    isColor = false
    color = ''
    magic =
        'WAZZ UP': 'img/Orange.jpg'
        'THUMB UP': 'img/thumb_up.jpg'
        '!!!': 'img/angry.png'
        'NOT GOOD': 'img/notgood.png'
        'THAT\'S COOL': 'img/cool.jpg'
        'WTF': 'img/wtf_bean.jpg'
        'FUCK': 'img/fuck.gif'
        'SUP': 'img/sup.jpg'
        'LOL': 'img/lol.jpg'
        'OOPS': 'img/oops.jpeg'
        'XIXI': 'img/xixi.jpeg'
        'HEIHEI': 'img/heihei.png'
        'CONGRATS': 'img/congrats.jpg'
        '...': 'img/nocomments.jpg'
        'LTYC': 'img/ltyc.jpeg'
        'WHAT??!!': 'img/what.jpg'
        'BUT WHY?': 'img/butwhy.jpeg'
        'THX': 'img/thx.jpeg'
        'HAHA': 'img/haha.gif'
        'HAHAHA': 'img/haha_yao.jpg'
        'SO FUNNY': 'img/so-funny.jpg'
        'NO!': 'img/no.jpg'
        'NOT BAD': 'img/not_bad_1.jpeg'

    user = null
    sendSound = document.getElementById('sendAudio')
    msgSound = document.getElementById('msgAudio')
    old = ''

    $('#chat_main_table').hide()
    $('#homepage_input_id').focus()
    $('.pick_table').hide()

    $('#homepage_button').click( ->
        if $('#homepage_input_id').val() is ''
            alert 'Please enter your nickname.'
            return
        $('#homepage_input_session').val GLOBAL_PUBLIC if $('#homepage_input_session').val() is ''
        $('#chat_main_table').show()
        $('#msg_input').focus()
        user = new User $('#homepage_input_id').val(), $('#homepage_input_session').val()
        document.title = user.getId() + '@' + user.getSession() + ' -- WebMsg'
        title = document.title
        source = new EventSource 'php/sse.php?session=' + user.getSession()
        source.onmessage = (event) ->
            if event.data isnt old
                isNew = true + title if not isFocused
                if event.data is 'do a barrel roll'
                    $('#msg_div').html old
                    if rolled is false
                        barrelRoll()
                        rolled = true
                    return

                rolled = false
                msgSound.play()
                old = event.data
                $('#msg_div').html old
                $('#msg_div').scrollTop($('#msg_div')[0].scrollHeight)
    )

    $('#msg_input_button').click( ->
        return if $('#msg_input').val() is ''
        if $('#msg_input').val() is 'darkscreen'
            $('#msg_input').val ''
            darkScreen()
            return
        if $('#msg_input').val() is 'brightscreen'
            $('#msg_input').val ''
            brightScreen()
            return
        if $('#msg_input').val() is 'barrelroll'
            $('#msg_input').val ''
            barrelRoll()
            return
        if $('#msg_input').val() is 'showmehistory'
            $('#msg_input').val ''
            showHistory()
            return
        if $('#msg_input').val() is 'whereami'
            $('#msg_input').val whereami()
            return
        if $('#msg_input').val() is 'whoami'
            $('#msg_input').val whoami()
            return
        if $('#msg_input').val() is 'colorme' or $('#msg_input').val() is 'colourme'
            isColor = true
            color = getRandomColor()
            $('#msg_input').val ''
            return
        if $('#msg_input').val() is 'nocolor' or $('#msg_input').val() is 'nocolour'
            isColor = false
            color = ''
            $('#msg_input').val ''
            return
        if (value = magic[$('#msg_input').val().toUpperCase()])?
            msg = encodeURIComponent Checkurl 'img:' + value
        else
            msg = encodeURIComponent Checkurl $('#msg_input').val() if not isColor
            if isColor
                msg = Checkurl $('#msg_input').val()
                msg = encodeURIComponent '<span class="shadow_text" style="color: ' + color + '">' + msg + '</span>'
        $('#msg_input').val ''
        $.ajax({
            url: 'php/send.php?user=' + user.getId() + '&session=' + user.getSession() + '&msg=' + msg
        })
        # sendSound.play()
    )

    $('#homepage_input_id, #homepage_input_session').keypress (event) ->
        if event.which is 13
            event.preventDefault()
            $('#homepage_button').click()

    $('#msg_input').keypress (event) ->
        if event.which is 13
            event.preventDefault()
            $('#msg_input_button').click()

    $('.pick_td, .pick_tr').click( ->
        $('#pick_div').html ''
        $('.pick_table').hide()
    )

    $('#mute_box').change( ->
        element = document.getElementById('mute_box')
        msgSound.muted = true if element.checked is true
        msgSound.muted = false if element.checked is false
    )

    $([window, document, 'table', 'input']).focusin( ->
        document.title = title
        isFocused = true
        isNew = false
        msgSound.muted = true
    ).focusout( ->
        isFocused = false
        msgSound.muted = false if document.getElementById('mute_box').checked is false
        msgSound.muted = true if document.getElementById('mute_box').checked is true
    )

    whereami = ->
        user.getSession()
    
    whoami = ->
        user.getId()

    setInterval( ->
        return if not user?
        if not isFocused and isNew
            if document.title is title
                document.title = 'New Message'
            else
                document.title = title
    , 1000)

    Checkurl = (text) ->
        url1 = /(^|&lt;|\s)(www\..+?\..+?)(\s|&gt;|$)/g
        url2 = /(^|&lt;|\s)(((https?|ftp):\/\/|mailto:).+?)(\s|&gt;|$)/g
        url3 = /(^|&lt;|\s)(img\:.+?\..+?)(\s|&gt;|$)/g

        html = $.trim(text)
        if html
            html = html.replace(url1, '$1<a style="color:blue; text-decoration:underline;" target="_blank"  href="http://$2">$2</a>$3').replace(url2, '$1<a style="color:blue; text-decoration:underline;" target="_blank"  href="$2">$2</a>$5').replace(url3, '$1<img width="100%" src="$2"/>&nbsp;$3').replace(/src=\"img\:/g, 'src="')

        return html

    getRandomColor = ->
        letters = '0123456789ABCDEF'.split('')
        color = '#'
        color += letters[Math.round(Math.random() * 15)] for i in [0..5]
        color

    showHistory = ->
        $.ajax({
            url: 'php/all.php?session=' + user.getSession()
        }).done( (msg) ->
            $('.pick_table').show()
            $('#pick_div').html msg
            $('#pick_div').scrollTop($('#pick_div')[0].scrollHeight)
        )

    barrelRoll = ->
        $('.chat_main_table').addClass 'barrel_roll'
        setTimeout ->
            $('.chat_main_table').removeClass 'barrel_roll'
        , 4000

    darkScreen = ->
        $('*').css 'background', 'black'
        $('input, label').css {'border': 'none', 'color': 'white'}

    brightScreen = ->
        $('*').css 'background', 'white'
        $('input').css {'border': 'thin solid grey', 'color': 'black'}
        $('label').css 'color': 'black'

