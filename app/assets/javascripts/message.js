$(document).ready( () => {

    $("#post_message").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            (data.status) ? $("#wrapper").prepend(data.result.html) & alert("Successfully posted") : alert(data.error);
            $(".message-textarea").val("");
        });

        return false;
    });

    $("#delete_message").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            (data.status) ? alert("Successfully deleted") : alert(data.error);
        });

        return false;
    });

    $("#wrapper").on("click", ".delete_message_btn", deleteMessage);
});

function deleteMessage() {
    let message_id = $(this).attr("data-message_id");
    let message_user_id = $(this).attr("data-message_user_id");
    let form = $(this);

    $(".message_id_del").val(message_id);
    $(".message_user_id_del").val(message_user);
    form.closest(".message-comment-wrapper").remove();
    $("#delete_message").submit();

    $(".message_id_del").val();
    $(".message_user_id_del").val();
}