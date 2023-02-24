$(document).ready( () => {

    $("#post_comment").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);
        
        $.post(form.attr("action"), $(form).serialize(), (data) => {
            (data.status) ? $("#message-comment_"+data.result.comment.message_id).append(data.result.html) & alert("Successfully posted") : alert(data.error);
            
        });

        return false;
    });

    $("#delete_comment").on("submit", function (e) {
        e.preventDefault();
        let form = $(this);

        $.post(form.attr("action"), $(form).serialize(), (data) => {
            (data.status) ? alert("Successfully deleted") : alert(data.error);
        }, "json");

        return false;
    });

    $("#wrapper").on("click", ".comment_post_btn", addComment);
    $("#wrapper").on("click", ".delete_comment_btn", deleteComment);
});

function addComment() {
    let comment_user_id = $(this).attr("data-user_id");
    let comment_message_id = $(this).attr("data-message_id");
    let form = $("#comment-content_"+comment_message_id).val();

    $(".comment_user_id_add").val(comment_user_id);
    $(".comment_message_id_add").val(comment_message_id);
    $(".comment_add").val(form);
    $("#comment-content_"+comment_message_id).val("");
    $("#post_comment").submit();
    
}

function deleteComment() {
    let comment_id = $(this).attr("data-comment_id");
    let comment_user_id = $(this).attr("data-comment_user_id");
    let form = $(this);

    $(".comment_id_del").val(comment_id);
    $(".comment_user_id_del").val(comment_user_id);
    form.closest(".comment").remove();
    $("#delete_comment").submit();

    $(".comment_id_del").val();
    $(".comment_user_id_del").val();
}