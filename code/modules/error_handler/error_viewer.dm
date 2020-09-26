var/global/datum/error_viewer/error_cache/error_cache = null

/datum/error_viewer
	var/name = ""
	var/static/datum/error_viewer/singleton = null

/datum/error_viewer/New()
	if(singleton)
		cdel(src)
		return

	singleton = src
	error_cache = singleton

/datum/error_viewer/proc/browse_to(client/user, html)
	var/datum/browser/browser = new(user.mob, "error_viewer", "<div align='center'>Runtime Viewer</div>", 600, 400)
	browser.set_content(html)
	browser.add_head_content({"
	<style>
	.runtime
	{
		background-color: #171717;
		border: solid 1px #202020;
		font-family: "Courier New";
		padding-left: 10px;
		color: #CCCCCC;
	}
	.runtime_line
	{
		margin-bottom: 10px;
		display: inline-block;
	}
	</style>
	"})
	browser.open()

/datum/error_viewer/proc/show_to(user)
	// Specific to each child type
	return

/datum/error_viewer/error_cache
	var/list/errors = list()
	var/list/errors_stack_traces = list()
	var/list/errors_fired = list()


/datum/error_viewer/error_cache/show_to(user)
	var/html = "<b>[total_runtimes]</b> runtimes, <b>[total_runtimes_skipped]</b> are skipped<hr><hr>"
	for(var/erroruid in errors)
		html += "<b>[errors[erroruid]]:</b><br>Fired [errors_fired[erroruid]] times.<br>Stack trace: [errors_stack_traces[erroruid]]<hr>"

	browse_to(user, html)
