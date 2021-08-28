import { check, sleep } from 'k6'
import VenueLessClient from './client.js'

import { getRandomNormalDist } from './utils.js'

const SILENT_USER_PROPABILITY = 0.999
const MEAN_TIME_TO_CHAT_MESSAGE = 15000 // 15s

export const options = {
	scenarios: {
		flood: {
			executor: 'ramping-vus',
			startVUs: 0,
			stages: [
				{ duration: '10m', target: 60000 },
				{ duration: '1m', target: 0 },
			],
			gracefulRampDown: '0s',
		}
	},
	thresholds: {
		'checks{ping:no-timeout}': [{threshold: 'rate>0.95', abortOnFail: true}],
		chat_message: [{threshold: 'p(90)<10000', abortOnFail: true}],
		request_response: [{threshold: 'p(90)<10000', abortOnFail: true}],
		connection_errors: [{threshold: 'rate<0.05'}]
	}
}

export default function () {
	const client = new VenueLessClient(__ENV.WS_URL)
	client.init(() => {
		const stage = client.stages[0]
		client.joinRoom(stage)

		const chat = () => {
			client.sendChatMessage()
			client.setTimeout(chat, getRandomNormalDist() * MEAN_TIME_TO_CHAT_MESSAGE * 2)
		}
		if (Math.random() < SILENT_USER_PROPABILITY) return
		client.setTimeout(chat, getRandomNormalDist() * MEAN_TIME_TO_CHAT_MESSAGE * 2)
	})
}
