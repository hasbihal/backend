import { Socket, Presence } from "phoenix";
import _ from "lodash";

let socket = new Socket("/socket", {
  // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) },
  params: { token: window.userToken }
});

let input = $("#message");
let messages_jq = input.closest('.chat-app').find('.messages');
let messages_el = document.getElementById("messages");

setTimeout(() => {
  messages_el.scrollTop = messages_el.scrollHeight;
}, 1000);

if (input.length > 0) {
  socket.connect();

  // Now that you are connected, you can join channels with a topic:
  let channel = socket.channel(`chat:${window.conversationKey}`, { token: window.userToken });

  channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.error("Connection failed! Because of ", resp);

    input.prop("disabled", true);
    input.next('label').text(`${resp.reason}`);
  });

  let presences = {}
  channel.on("presence_state", (resp) => {
    presences = Presence.syncState(presences, resp);
    renderChips(presences)
  })

  channel.on("presence_diff", (resp) => {
    presences = Presence.syncDiff(presences, resp);
    renderChips(presences)
  })

  let renderChips = (presences) => {
    $('#info').html(_.map(Presence.list(presences, (id, { metas: [user, ...rest] }) => {
      if (parseInt(id) !== window.userId) {
        return renderUser(user)
      }
      return null
    })).join(""));
  }

  let renderUser = (user) => {
    let typing = ''
    if (user.typing) {
      typing = ' <em>(typing...)</em>'
    }
    return `<span class="status-dot online"></span> ${user.name} ${typing}`;
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
}

export default socket
