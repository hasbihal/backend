import { Socket, Presence } from "phoenix";
import _ from "lodash";
import Dropzone from "dropzone";

let socket = new Socket("/socket", {
  // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) },
  params: { token: window.userToken }
});

let input = $("#message");

if (input.length > 0) {
  let messages_jq = input.closest('.chat-app').find('#messages');
  let messages_el = document.getElementById("messages");

  const dropzone = new Dropzone("#messages", {
    url: "/api/v1/files",
    method: "post",
    clickable: false,
    paramName: "file[file]",
    acceptedFiles: "image/*",
    previewTemplate: document
      .querySelector('#dropzone-tpl')
      .innerHTML,
    sending: (_file, _xhr, formData) => {
      formData.append("file[user_token]", window.userToken);
      formData.append("file[conversation_key]", window.conversationKey);
    },
    success: (file, response) => {
      channel.push("file:new", {
        file_id: response.data.id
      });

      messages_el.scrollTop = messages_el.scrollHeight;
    }
  });

  setTimeout(() => {
    messages_el.scrollTop = messages_el.scrollHeight;
  }, 1000);

  socket.connect();

  // Now that you are connected, you can join channels with a topic:
  let channel = socket.channel(`chat:${window.conversationKey}`, { token: window.userToken });

  setTimeout(() => {
    fetch(`${window.conversationKey}/seen`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": $('meta[name=csrf-token]').attr('content'),
      }
    }).then(function (_response) {
      // console.log(response.json());
    });
  }, 5000);

  channel.join()
  .receive("ok", _resp => {
    // console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.error("Connection failed! Because of ", resp);

    input.prop("disabled", true);
    input.next('label').text(`${resp.reason}`);
  });

  let presences = {}
  channel.on("presence_state", (resp) => {
    presences = Presence.syncState(presences, resp);
    receiverStatus(presences)
  })

  channel.on("presence_diff", (resp) => {
    presences = Presence.syncDiff(presences, resp);
    receiverStatus(presences)
  })

  let receiverStatus = (presences) => {
    const receiver = _.map(Presence.list(presences, (id, { metas: [user, ...rest] }) => {
      if (parseInt(id) !== window.userId) {
        $('.user-informations img.user-avatar').addClass('online')

        if (user.typing) {
          $('.typing-info').show();
        } else {
          $('.typing-info').hide();
        }
      }
    }))
  }

  input.focus();
  input.on("keypress", (event) => {
    if (event.shiftKey) {
      return;
    }
    if (event.keyCode === 13) {
      if (input.val().replace(/\s/g, "").length === 0) {
        if (input.next('span.mdl-textfield__error').length === 0) {
          input.after("<span class='mdl-textfield__error' id='error'>Please write something!</span>");
        }
        input.parent().addClass("is-invalid");
      } else {
        channel.push("message:new", {
          message: input.val().replace(/^\s+/g, '')
        });

        input.val("");
        input.parent().removeClass("is-invalid");
        input.next("span.mdl-textfield__error").remove();
      }
    }
  });

  const typingTimeout = 2000;
  let typingTimer;
  let userTyping = false;
  const userStartsTyping = function () {
    if (userTyping) { return }
    userTyping = true
    channel.push('user:typing', { typing: true })
  }

  const userStopsTyping = function () {
    clearTimeout(typingTimer);
    userTyping = false
    channel.push('user:typing', { typing: false })
  }

  input.on('keydown', () => {
    userStartsTyping()
    clearTimeout(typingTimer);
  })
  input.on('keyup', () => {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(userStopsTyping, typingTimeout);
  })

  channel.on('message:new', (payload) => {
    messages_jq.append(`<div class="message-item ${window.userId === payload.user.id ? 'mine' : 'their'}">
      ${payload.message.replace(/(?:\r\n|\r|\n)/g, '<br>')}
    </div>`);

    messages_el.scrollTop = messages_el.scrollHeight;
  });

  channel.on('file:new', (payload) => {
    if (window.userId !== payload.user.id) {
      messages_jq.append(`<div class="message-item ${window.userId === payload.user.id ? 'mine' : 'their'}">
        ${payload.file.file_name}<br/>
        <img src="${payload.file.file_url}" style="max-width: 100px"/>
      </div>`);

      messages_el.scrollTop = messages_el.scrollHeight;
    }
  });
}

export default socket
