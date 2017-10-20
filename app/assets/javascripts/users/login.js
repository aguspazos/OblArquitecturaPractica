$(document).ready(function () {
    $('#send').on({
        'click': function () {
            var user = $('#user').val();
            var pass = $('#password').val();
            $.ajax({
                type: 'POST',
                url: '',
                data: { 'user': (user), 'password': (pass) },
                success: function (response) {
                    
                },
                error: function () {
                    
                }
            });
        }
    });
});