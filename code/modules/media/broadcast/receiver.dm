// frequency => list(listeners)
var/global/media_receivers=list()


///////////////////////
// RECEIVERS
///////////////////////

/obj/machinery/media/receiver
	var/media_frequency = 1234 // 123.4 MHz
	var/media_crypto    = null // Crypto key

/obj/machinery/media/receiver/New()
	..()
	connect_frequency()

/obj/machinery/media/receiver/proc/receive_broadcast(var/url="", var/start_time=0)
	media_url = url
	media_start_time = start_time
	update_music()

/obj/machinery/media/receiver/proc/connect_frequency()
	// This is basically media_receivers[media_frequency] += src
	var/list/receivers=list()
	if(media_frequency in media_receivers)
		receivers = media_receivers[media_frequency]
	receivers.Add(src)
	media_receivers[media_frequency]=receivers

	// Check if there's a broadcast to tune into.
	if(media_frequency in media_transmitters)
		// Pick a random broadcast in that frequency.
		var/obj/machinery/media/transmitter/B = pick(media_transmitters[media_frequency])
		if(B.media_crypto == media_crypto) // Crypto-key check, if needed.
			receive_broadcast(B.media_url,B.media_start_time)

/obj/machinery/media/receiver/proc/disconnect_frequency()
	var/list/receivers=list()
	if(media_frequency in media_receivers)
		receivers = media_receivers[media_frequency]
	receivers.Remove(src)
	media_receivers[media_frequency]=receivers

	receive_broadcast()
