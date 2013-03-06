$ ->
    title = ''
    isFocused = true
    isNew = false
    magic =
        'WTF': 'img/wtf.jpg'
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

    user = null
    sendSound = document.getElementById('sendAudio')
    msgSound = document.getElementById('msgAudio')
    old = ''

    $('#chat_main_table').hide()
    $('#homepage_input_id').focus()
    $('.pick_table').hide()

    $('#homepage_button').click( ->
        if $('#homepage_input_id').val() is '' or $('#homepage_input_session').val() is ''
            alert 'Incomplete user input.'
            return
        $('#chat_main_table').show()
        $('#msg_input').focus()
        user = new User $('#homepage_input_id').val(), $('#homepage_input_session').val()
        document.title = user.getId() + '@' + user.getSession() + ' -- WebMsg'
        title = document.title
        source = new EventSource 'php/sse.php?session=' + user.getSession()
        source.onmessage = (event) ->
            if event.data isnt old
                isNew = true + title if not isFocused
                msgSound.play()
                old = event.data
                $('#msg_div').html old
                $('#msg_div').scrollTop($('#msg_div')[0].scrollHeight)
    )

    $('#msg_input_button').click( ->
        return if $('#msg_input').val() is ''
        if $('#msg_input').val() is 'whereami'
            $('#msg_input').val whereami()
            return
        if (value = magic[$('#msg_input').val().toUpperCase()])?
            msg = encodeURIComponent Checkurl 'img:' + value
        else
            msg = encodeURIComponent Checkurl $('#msg_input').val()
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

    $('#msg_div').click( ->
        $.ajax({
            url: 'php/all.php?session=' + user.getSession()
        }).done( (msg) ->
            $('.pick_table').show()
            $('#pick_div').html msg
            $('#pick_div').scrollTop($('#pick_div')[0].scrollHeight)
        )
    )

    $('.pick_td, .pick_tr').click( ->
        $('#pick_div').html ''
        $('.pick_table').hide()
    )

    $('#mute_box').change( ->
        element = document.getElementById('mute_box')
        msgSound.muted = true if element.checked is true
        msgSound.muted = false if element.checked is false
    )

    $([window, document]).focusin( ->
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

