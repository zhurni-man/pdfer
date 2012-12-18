$(function() {
	$(".toggle").click(function() {
		$(".gmapa").toggle();
	});
	$(".draggable").draggable({ helper: "clone", opacity: 0.7 });
	$(".droppable").droppable({
		accept: ".draggable",
		activeClass: "ui-state-hover",
		hoverClass: "ui-state-active",
		drop: function(event, ui) {
			var droppedItem = ui.draggable;
			$(this)
					.addClass("ui-state-highlight")
					.val( $.trim(droppedItem.text()) );
		}
	});
});