<template lang="pug">
.c-emoji
</template>
<script>
import { h, render } from 'preact'
import 'emoji-mart/css/emoji-mart.css'
import data from 'emoji-mart/data/twitter.json'
import { EmojiNimble } from 'emoji-mart'

export default {
	components: {},
	data () {
		return {
		}
	},
	computed: {},
	mounted () {
		const picker = h(EmojiNimble, {
			set: 'twitter',
			data,
			onSelect: emoji => console.log('emoji selected', emoji),
			title: 'Emoji',
			showPreview: true
		})
		render(picker, this.$el)
	},
	methods: {}
}
</script>
<style lang="stylus">
</style>
