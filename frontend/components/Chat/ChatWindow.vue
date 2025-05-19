<template>
  <div
    class="relative flex flex-col items-center justify-between h-screen bg-gray-100"
  >
    <!-- Label informativo (solo al inicio) -->
    <div
      v-if="messages.length === 0"
      class="mt-20 text-gray-700 text-lg px-4 py-2 bg-white rounded shadow"
    >
      💬 Hola soy <"nombre del asistente">, ¿en qué puedo ayudarte hoy?
    </div>

    <!-- Mensajes del chat -->
    <div
      ref="chatContainer"
      class="flex-1 w-full overflow-y-auto px-4 py-6 space-y-4 flex flex-col items-center pb-[100px]"
    >
      <div class="w-full max-w-xl flex flex-col space-y-4">
        <ChatMessage
          v-for="(msg, index) in messages"
          :key="index"
          :text="msg.text"
          :isUser="msg.isUser"
        />
        <!-- 👇 Elemento ancla para scroll automático -->
        <!-- <div ref="chatEnd" class="h-1"></div> -->
      </div>
    </div>

    <!-- Input fijo, centrado y tipo burbuja -->
    <form
      @submit.prevent="sendMessage"
      class="absolute bottom-4 w-full flex justify-center pointer-events-none"
    >
      <div
        class="flex bg-white border rounded-full shadow-md px-4 py-2 items-center w-[90%] max-w-xl pointer-events-auto"
      >
        <input
          v-model="newMessage"
          type="text"
          placeholder="Escribe tu mensaje..."
          class="flex-1 outline-none px-2 py-1 text-lg bg-transparent"
        />
        <input
          type="file"
          ref="fileInput"
          accept=".pdf"
          class="hidden"
          @change="handleFileUpload"
        />
        <button
          type="button"
          @click="triggerFileUpload"
          class="p-2 rounded-full hover:bg-gray-100 transition"
        >
          <IconPaperclip class="w-6 h-6 text-gray-500 hover:text-gray-700" />
        </button>
        <button
          type="submit"
          class="bg-blue-500 text-white text-mg px-4 py-1 rounded-full hover:bg-blue-600"
        >
          Enviar
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from "vue";
import ChatMessage from "./ChatMessage.vue";
import { IconPaperclip } from "@tabler/icons-vue";


interface Message {
  text: string;
  isUser: boolean;
}

const messages = ref<Message[]>([]); // ✅ correcto

const newMessage = ref("");
const fileInput = ref<HTMLInputElement | null>(null);
const chatContainer = ref<HTMLElement | null>(null);
const chatEnd = ref<HTMLElement | null>(null); // 👈 NUEVO

// Scroll automático hacia el "ancla"
function scrollToBottom(force = false) {
  if (chatContainer.value) {
    requestAnimationFrame(() => {
      chatContainer.value!.scrollTop = chatContainer.value!.scrollHeight;
    });

    if (force) {
      setTimeout(() => {
        chatContainer.value!.scrollTop = chatContainer.value!.scrollHeight;
      }, 150);
    }
  }
}

// 🔄 Auto scroll cuando cambia la lista de mensajes
watch(messages, async () => {
  await nextTick();
  scrollToBottom(true);
});

// Extra: scroll también al montar (por si hay mensajes previos)
onMounted(() => {
  scrollToBottom();
});


async function sendMessage() {
  if (!newMessage.value.trim()) return;

  const userPrompt = newMessage.value;

  // Mostrar mensaje del usuario
  messages.value.push({ text: userPrompt, isUser: true });
  newMessage.value = "";

  // Mostrar respuesta temporal
  messages.value.push({ text: "Escribiendo...", isUser: false });

  try {
    const response = await fetch("http://127.0.0.1:5000/chatbot", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ prompt: userPrompt }),
    });

    const replyText = await response.text();

    // Reemplaza "Escribiendo..." por respuesta real
    messages.value.splice(messages.value.length - 1, 1, {
      text: replyText,
      isUser: false,
    });
  } catch (error) {
    messages.value.splice(messages.value.length - 1, 1, {
      text: "❌ Error al contactar al asistente.",
      isUser: false,
    });
    console.error(error);
  }
}


function triggerFileUpload() {
  fileInput.value?.click();
}

function handleFileUpload(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0];
  if (file && file.type === "application/pdf") {
    messages.value.push({
      text: `📄 Archivo cargado: ${file.name}`,
      isUser: true,
    });

    // Aquí podrías usar PDF.js o enviarlo a tu backend para análisis
  }
}
</script>
