// data driven mode:
// configure with {propName} to start/close via a data property
// starts listening to events when prop gets true and sets prop to false when triggered
// function driven mode:
// configure with {startMethodName, closeMethodName}
// Call startMethodName to start listening for mousedown and keydown events on document
// Calls closeMethodName method on global event

const targetInParent = function (target, $el) {
	if (target === $el) return true
	if (target === document.body) return false
	return targetInParent(target.parentElement, $el)
}

export default function (config) {
	const mixin = {
		destroyed () {
			this.__cogiDestroyListeners()
		},
		methods: {
			[config.startMethodName || '__cogiStart'] () {
				if (!this.__cogilistener) {
					this.__cogilistener = (event) => {
						if (targetInParent(event.target, this.$el) || event.ctrlKey || event.altKey || event.metaKey) return
						if (config.propName) this[config.propName] = false
						if (config.closeMethodName) {
							this.__cogiDestroyListeners()
							this[config.closeMethodName]()
						}
					}
					document.addEventListener('mousedown', this.__cogilistener, {capture: true})
					document.addEventListener('keydown', this.__cogilistener, {capture: true})
				}
			},
			__cogiDestroyListeners () {
				document.removeEventListener('mousedown', this.__cogilistener, {capture: true})
				document.removeEventListener('keydown', this.__cogilistener, {capture: true})
				this.__cogilistener = null
			}
		}
	}

	if (config.propName) {
		mixin.watch = {
			[config.propName] (value) {
				if (value) this.__cogiStart()
				else this.__cogiDestroyListeners()
			}
		}
	}
	return mixin
}
