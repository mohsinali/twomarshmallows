# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  Paloma.controller 'Teachers',
    index: ->
      openSidenav = ->
        $('.clients-wrapper').addClass 'clients-sidebox-open'
        return

      closeSidenav = ->
        $('.clients-wrapper').removeClass 'clients-sidebox-open'
        $('.clients-table tr.bg-light').removeClass 'bg-light'
        return

      selectClient = (row) ->
        teacher_id = $(row).attr("data-id")

        openSidenav()
        $('.clients-table tr.bg-light').removeClass 'bg-light'
        $(row).addClass 'bg-light'

        $(".side-box-body").html("")
        $(".loader").removeClass('d-none')

        $.ajax
          type: 'GET'
          contentType: 'application/javascript; charset=utf-8'
          url: '/teachers/sidebox_detail/' + teacher_id
          dataType: 'script'

        return

      ## Quill Editor for email
      editor_email = new Quill('#quill-editor-email',
        modules: toolbar: '#quill-toolbar-email'
        placeholder: 'Type something'
        theme: 'snow')

      $('.lnk-schedule-interview').click ->
        $("#schedule-interview-modal").modal 'show'


      $('.lnk-send-email').on 'click', ->
        total_count = $(this).attr('data-total-count')
        bootbox.confirm
          message: "Are you sure you want to send email to " + total_count + " teachers?"
          className: 'bootbox-sm'
          callback: (result) ->
            if result
              $("#create-email-modal").modal 'show'
              $("#to").val('[Multiple Recipients]')
            return

      $(".btn-save-email").click ->
        $("#create-email-modal").modal 'hide'
        swal
          title: 'Hurrrah!!'
          text: 'The email process has start. It will complete in a few minutes.'
          type: 'success'
          showCancelButton: false
          confirmButtonClass: 'btn-success'
          confirmButtonText: 'Ok!'


      ## Select template and auto-fill email body
      $('.select-templates').change ->
        id = $(this).val()
        $.get "/email_templates/" + id + ".json", (data) ->
          editor_email.root.innerHTML = data["body"]
          return

      ## TODO: User some class for this.
      ################## Payments ##################
      $(document).on 'click', '.btn-pay', (event) ->
        if $('.payments:visible').length
          $('.payments').addClass('d-none')
        else
          $('.payments').removeClass('d-none')

      $(document).on 'click', '.btn-submit-payment', (event) ->
        $('.payment-form').validate
          rules:
            'amount':
                required: true
                number: true
            'payment_select': required: true
          messages:
            'amount': required: 'Amount is required.'
            'payment_select': required: 'Please select a status.'

          submitHandler: ->
            $('.form-submit-loader').removeClass('d-none')


      ######################################################

      $(document).on 'change', '.sequences-list', (event) ->
        if $(this).val() != ""
          sequence_id = $(this).val()
          teacher_id  = $(this).attr("data-teacher-id")

          $.ajax
            type: 'post'
            url: '/sequences/assign'
            data:
              'sequence_id': sequence_id
              'teacher_id': teacher_id
            dataType: 'script'

      $('body').on 'click', '.clients-table tr', ->
        # Load client data here
        # ...
        # Select client
        selectClient this
        return

      $('body').on 'click', '.clients-sidebox-close', (e) ->
        e.preventDefault()
        closeSidenav()
        return

      # Setup scrollbars
      $('.clients-scroll').each ->
        new PerfectScrollbar(this,
          suppressScrollX: true
          wheelPropagation: true)
        return

      $('#tickets-list-created').daterangepicker
        ranges:
          'Today': [ moment(), moment() ]
          'Yesterday': [ moment().subtract(1, 'days'), moment().subtract(1, 'days') ]
          'Last 7 Days': [ moment().subtract(6, 'days'), moment() ]
          'Last 30 Days': [ moment().subtract(29, 'days'), moment() ]
          'This Month': [ moment().startOf('month'), moment().endOf('month') ]
          'Last Month': [ moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month') ]
        opens: 'left'

    show: ->

      ## Quill RTE initialization
      if !window.Quill
        $('#quill-editor-note').remove()

      ## Quill Editor for notes
      editor_note = new Quill('#quill-editor-note',
        modules: toolbar: '#quill-toolbar-note'
        placeholder: 'Type something'
        theme: 'snow')

      ## Quill Editor for tasks
      editor_task = new Quill('#quill-editor-task',
        modules: toolbar: '#quill-toolbar-task'
        placeholder: 'Type something'
        theme: 'snow')

      ## Quill Editor for meeting
      editor_meeting = new Quill('#quill-editor-meeting',
        modules: toolbar: '#quill-toolbar-meeting'
        placeholder: 'Type something'
        theme: 'snow')

      ## Quill Editor for email
      editor_email = new Quill('#quill-editor-email',
        modules: toolbar: '#quill-toolbar-email'
        placeholder: 'Type something'
        theme: 'snow')
      ## ###########################

      ## Open create note modal
      $(".lnk-note").click ->
        $("#create-note-modal").modal 'show'

        ## Reset editor
        editor_note.root.innerHTML = ""

      ## Open create task modal
      $(".lnk-task").click ->
        $("#create-task-modal").modal 'show'

        ## Reset editor
        editor_task.root.innerHTML = ""

      ## Open create meeting modal
      $(".lnk-meeting").click ->
        $("#create-meeting-modal").modal 'show'

        ## Reset editor
        editor_meeting.root.innerHTML = ""


      ## Open create email modal
      $(".lnk-email").click ->
        $("#create-email-modal").modal 'show'

        ## Reset editor
        editor_email.root.innerHTML = ""


      ## DatePicker for Task DueDate
      initializeDatePicker('due_date')

      ## DatePicker for Meeting start_time
      initializeDatePicker('start_time')


      ## Post editor data/content to server - Notes
      $(".btn-save-note").click ->
        ## Disable submit button to prevent multiple submissions.
        $(".btn-save-note").attr("disabled", true)
        teacher_id = $(this).attr("data-teacher-id")

        $.ajax
          type: 'post'
          url: '/notes'
          data:
            'notes': 'description': editor_note.root.innerHTML
            'teacher_id': teacher_id
          dataType: 'script'
          success: (response) ->
            $(".btn-save-note").attr("disabled", false)
            return
          error: ->
            $(".btn-save-note").attr("disabled", false)
            return

      ## Post editor data/content to server - Tasks
      $(".btn-save-task").click ->
        ## Disable submit button to prevent multiple submissions.
        $(".btn-save-task").attr("disabled", true)
        teacher_id = $(this).attr("data-teacher-id")

        $.ajax
          type: 'post'
          url: '/tasks'
          data:
            'tasks':
              'title': $("#title").val()
              'description': editor_task.root.innerHTML
              'due_date': $("#due_date").val()
            'teacher_id': teacher_id
          dataType: 'script'
          success: (response) ->
            $(".btn-save-task").attr("disabled", false)
            return
          error: ->
            $(".btn-save-task").attr("disabled", false)
            return

      ## Post editor data/content to server - Meeting
      $(".btn-save-meeting").click ->
        ## Disable submit button to prevent multiple submissions.
        $(".btn-save-meeting").attr("disabled", true)
        teacher_id = $(this).attr("data-teacher-id")

        $.ajax
          type: 'post'
          url: '/meetings'
          data:
            'meeting':
              'title': $("#title").val()
              'description': editor_meeting.root.innerHTML
              'start_time': $("#start_time").val()
              'duration': $("#duration").val()
            'teacher_id': teacher_id
          dataType: 'script'
          success: (response) ->
            $(".btn-save-meeting").attr("disabled", false)
            console.log(response)
            return
          error: ->
            $(".btn-save-meeting").attr("disabled", false)
            return

      ## Post editor data/content to server - Email
      $(".btn-save-email").click ->
        ## Disable submit button to prevent multiple submissions.
        $(".btn-save-email").attr("disabled", true)
        teacher_id = $(this).attr("data-teacher-id")

        $.ajax
          type: 'post'
          url: '/emails'
          data:
            'compose':
              'to': $("#to").val()
              'subject': $("#subject").val()
              'body': editor_email.root.innerHTML
            'teacher_id': teacher_id
          dataType: 'script'
          success: (response) ->
            $(".btn-save-email").attr("disabled", false)
            console.log(response)
            return
          error: ->
            $(".btn-save-email").attr("disabled", false)
            return

      ## Select template and auto-fill email body
      $('.select-templates').change ->
        id = $(this).val()
        $.get "/email_templates/" + id + ".json", (data) ->
          editor_email.root.innerHTML = data["body"]
          return



      ## Mark task as complete
      $(document).on 'click', '.btn-complete', (event) ->
        task_id = $(this).attr('data-taskid')
        $.ajax
          type: 'post'
          url: '/tasks/update_status'
          data:
            'task_id': task_id
          dataType: 'script'
          success: (response) ->
            $(".btn-save-task").attr("disabled", false)
            return
          error: ->
            $(".btn-save-task").attr("disabled", false)
            return

      ## Load Thread counts
      promise = new GmailApi().get_thread_counts(this.params.thread_ids)

      promise.then (counts) ->
        $.each counts, (k, v) ->
          $("#" + k).html(v)
          $("#" + k).removeClass('d-none')
        return

    data: ->
      $('#exp-date').bootstrapMaterialDatePicker
        weekStart: 0,
        time: false,
        clearButton: true
      $('#start-date').bootstrapMaterialDatePicker
        weekStart: 0,
        time: false,
        clearButton: true

## Paloma docs
# https://libraries.io/github/kbparagua/paloma
