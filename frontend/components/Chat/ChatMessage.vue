<template>
    <div
      class="max-w-xs px-4 py-2 rounded-lg"
      :class="isUser ? 'bg-blue-500 text-white self-end' : 'bg-gray-300 text-black self-start'"
    >
      {{ text }}
    </div>
  </template>
  
  <script setup lang="ts">
  defineProps<{
    text: string;
    isUser: boolean;
  }>();
  </script>
  