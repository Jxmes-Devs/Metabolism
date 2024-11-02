function changePosition(element, className) {
	element.draggable({
		stop: function (event, ui) {
			var pos = ui.position;
			element.css({
				top: pos.top + "px",
				left: pos.left + "px",
			});
			$.post(
				`https://${GetParentResourceName()}/saveUIPosition`,
				JSON.stringify({
					x: pos.left,
					y: pos.top,
					className: className,
				})
			);
		},
	}).addClass(className);
}

document.onkeyup = function (data) {
	if (data.key == "Escape") {
		notify_container = document.getElementById("notify");
		notify_container.style.display = "none";
		notify_container.innerHTML = "temp";

		$.post(`https://${GetParentResourceName()}/saveEdit`, JSON.stringify({}));
	}
};

document.addEventListener("DOMContentLoaded", function () {

	document.body.style.display = "none";
	
	changePosition($(".health_container"), "health");
	changePosition($(".stamina_container"), "stamina");
	changePosition($(".horseHealth_container"), "horseHealth");
	changePosition($(".horseStamina_container"), "horseStamina");
	changePosition($(".hunger_container"), "hunger");
	changePosition($(".thirst_container"), "thirst");
	changePosition($(".voice_container"), "voice");
	changePosition($(".bath_container"), "bath");
	changePosition($(".temp_container"), "temp");
	changePosition($(".addiction_container"), "addiction");
	changePosition($(".temp_container"), "temp");
	changePosition($(".crowd_container"), "crowd");
	

	window.addEventListener("message", function (event) {
		
		let item = event.data;

		let voice_container = document.querySelector(".voice_container");
		let voice_icon = document.querySelector(".voiceIcon");
		let voice_mute = document.querySelector(".muteLine");
		let dirtUI = document.querySelector(".bath_container");
		let tempUI = document.getElementById("tempnumber");
		let addictionUI = document.querySelector(".addiction_container");
		
		playerHealth = document.querySelector(".health_container");
		playerStamina = document.querySelector(".health_container");
		horseHealth = document.querySelector(".horseHealth_container");
		horseStamina = document.querySelector(".horseStamina_container");
		
		if (item.action === "notify") {
			var message = '<span style="width:100%">' + item.textsent + "</span>";

			notify_container = document.getElementById("notify");
			notify_container.innerHTML = message;
			notify_container.style.display = "block";	
		}

		if (item.type === "UIposition") {
			let element = $(`.${event.data.className}`);
			element.css({
				top: event.data.y + "px",
				left: event.data.x + "px",
			});

		} else if (item.type === "edit") {
			document.body.style.display = "block";
			const classNames = [
				".hunger_container",
				".hunger_container",
				".thirst_container",
				".voice_container",
				".bath_container",
				".health_container",
				".stamina_container",
				".temp_container",
				".horseHealth_container",
				".horseStamina_container",
				".addiction_container"
			];

			classNames.forEach(className => {
				$(className).css("display", "block");
			});
		} else if (item.type === "HUD") {

			if (item.inCinematic === 1) {
				document.body.style.display = "none";
			} else {
				

				document.body.style.display = "block";
				tempUI.innerHTML = item.tempNumber;

				document.querySelector(".crowdIcon").style.fill = item.playerIndicator;

				if (item.voiceSystem === false) {
					voice_container.style.display = "none";
				} else {
					voice_container.style.display = "block";
					updateProgress(document.getElementById("voice-bar"),item.voiceRange, true)

					if (item.isMuted === true) {
						console.log(voice_mute);
						voice_mute.style.display = "block";
						voice_icon.querySelector('path').setAttribute('fill', 'white');
					} else if (item.isTalking === true) {
						console.log(item.isTalking);
						voice_mute.style.display = "none";
						voice_icon.querySelector('path').setAttribute('fill', 'red');
					} else {
						voice_icon.querySelector('path').setAttribute('fill', 'white');

						voice_mute.style.display = "none";
						}
					}

				if (item.dirt > 0) {
					updateProgress(document.getElementById("dirt-bar"),item.dirt,true);
					dirtUI.style.display = "block";
				} else {
					dirtUI.style.display = "none";
				}					

				// MAIN SYSTEMS
				if (item.onHorse === false) {
					horseHealth.style.display = "none";
					horseStamina.style.display = "none";
				} else {
					
					horseHealth.style.display = "block";
					horseStamina.style.display = "block";
					
					if (item.horseInnerHealthGold >= 1) {

						updateFill("horseHealthIcon", 100);
						updateFill("horseHealthIcon2", 100);


						const gradient = document.getElementById('horseHealthIconGradient');
						gradient.children[0].setAttribute('stop-color', '#FFD700');
						gradient.children[1].setAttribute('stop-color', '#DAA520');

						const gradient2 = document.getElementById('horseHealthIcon2Gradient');
						gradient2.children[0].setAttribute('stop-color', '#FFD700');
						gradient2.children[1].setAttribute('stop-color', '#DAA520');

						

					} else {
						updateFill("horseHealthIcon", item.horseInnerHealth);
						updateFill("horseHealthIcon2", item.horseInnerHealth);

						const gradient = document.getElementById('horseHealthIconGradient');
						gradient.children[0].setAttribute('stop-color', '#808080');
						gradient.children[1].setAttribute('stop-color', '#ffffff');

						const gradient2 = document.getElementById('horseHealthIcon2Gradient');
						gradient2.children[0].setAttribute('stop-color', '#808080');
						gradient2.children[1].setAttribute('stop-color', '#ffffff');

						
					}

					if (item.horseOuterHealthGold >= 1) {
						document.getElementById("horseHealth-bar").querySelector('.progressCircle').style.stroke = '#FFD700';
						updateProgress(document.getElementById("horseHealth-bar"), 100);
					} else {
						document.getElementById("horseHealth-bar").querySelector('.progressCircle').style.stroke = '#ffffff';
						updateProgress(document.getElementById("horseHealth-bar"), item.horseOuterHealth);
					}
					
					
					if (item.horseInnerStaminaGold >= 1) {

						updateFill("horseStaminaIcon", 100);
						updateFill("horseStaminaIcon2", 100);

						const gradient = document.getElementById('horseStaminaIconGradient');
						gradient.children[0].setAttribute('stop-color', '#FFD700');
						gradient.children[1].setAttribute('stop-color', '#DAA520');

						const gradient2 = document.getElementById('horseStaminaIcon2Gradient');
						gradient2.children[0].setAttribute('stop-color', '#FFD700');
						gradient2.children[1].setAttribute('stop-color', '#DAA520');

						

					} else {

						updateFill("horseStaminaIcon", item.horseInnerStamina);
						updateFill("horseStaminaIcon2", item.horseInnerStamina);

						const gradient = document.getElementById('horseStaminaIconGradient');
						gradient.children[0].setAttribute('stop-color', '#808080');
						gradient.children[1].setAttribute('stop-color', '#ffffff');

						const gradient2 = document.getElementById('horseStaminaIcon2Gradient');
						gradient2.children[0].setAttribute('stop-color', '#808080');
						gradient2.children[1].setAttribute('stop-color', '#ffffff');

						
					}

					if (item.horseOuterStaminaGold >= 1) {
						document.getElementById("horseStamina-bar").querySelector('.progressCircle').style.stroke = '#FFD700';
						updateProgress(document.getElementById("horseStamina-bar"), 100);
					} else {
						document.getElementById("horseStamina-bar").querySelector('.progressCircle').style.stroke = '#ffffff';
						updateProgress(document.getElementById("horseStamina-bar"), item.horseOuterStamina);
					}
					// HorseXpH.innerHTML = item.hXP;
					// HorseXpS.innerHTML = item.sXP;
				}

				// sprinting logic
				if (item.isrunning) {
					if (item.onHorse === false) {
						$(".thirstIcon, .innerStamina").css("animation", "pulseIcon 0.5s infinite");
						$(".stamina_container, .thirst_container").css("animation", "pulse 0.8s infinite");

					} else {
						// if in a horse and sprinting
						$(".horseStamina_container").css("animation", "pulse 0.5s infinite");
						$(".horseStaminaIcon, .horseStaminaIcon2").css("animation", "pulseIcon 0.5s infinite");

						
						$(".thirstIcon, .innerStamina").css("animation", "none");
						$(".stamina_container, .thirst_container").css("animation", "none");
						
						
					}
				} else {
					$(".stamina_container, .staminaIcon, .thirst_container, .horseStamina, .thirstIcon, .horseStamina_container, .horseStaminaIcon, .horseStaminaIcon2").css("animation", "none");
				}

				if (item.thirst <= 0) {
					$(".thirst_container").css("animation", "pulse 0.5s infinite");
					$(".thirstIcon").css("animation", "pulseIcon 0.5s infinite");
				}
				if (item.hunger <= 0) {
					$(".hunger_container").css("animation", "pulse 0.5s infinite");
					$(".hungerIcon").css("animation", "pulseIcon 0.5s infinite");
				}

				// HEALTH / STAMINA / HUNGER / THIRST BARS
				if (item.innerHealthGold >= 1) {
					updateFill('innerHealth', item.innerHealthGold);
					// Set gold colors
					const gradient = document.getElementById('innerHealthGradient');
					gradient.children[0].setAttribute('stop-color', '#FFD700');
					gradient.children[1].setAttribute('stop-color', '#DAA520');
				} else {
					const gradient = document.getElementById('innerHealthGradient');
					gradient.children[0].setAttribute('stop-color', '#808080');
					gradient.children[1].setAttribute('stop-color', '#ffffff');
					updateFill('innerHealth', item.innerHealth);
				}

				if (item.outerHealthGold >= 1) {
					document.getElementById("health-bar").querySelector('.progressCircle').style.stroke = '#FFD700';
					updateProgress(document.getElementById("health-bar"), 100);
				} else {
					document.getElementById("health-bar").querySelector('.progressCircle').style.stroke = '#ffffff';
					updateProgress(document.getElementById("health-bar"), item.outerHealth);
				}
				
				if (item.innerStaminaGold >= 1) {
					// Set gold colors
					updateFill('innerStamina', item.innerStaminaGold);

					const gradient = document.getElementById('innerStaminaGradient');
					gradient.children[0].setAttribute('stop-color', '#FFD700');
					gradient.children[1].setAttribute('stop-color', '#DAA520');
					
				} else {
					const gradient = document.getElementById('innerStaminaGradient');
					gradient.children[0].setAttribute('stop-color', '#808080');
					gradient.children[1].setAttribute('stop-color', '#ffffff');
					updateFill('innerStamina', item.innerStamina);
				}

				if (item.outerStaminaGold >= 1) {
					document.getElementById("stamina-bar").querySelector('.progressCircle').style.stroke = '#FFD700';
					updateProgress(document.getElementById("stamina-bar"),100);
				} else {
					document.getElementById("stamina-bar").querySelector('.progressCircle').style.stroke = '#ffffff';
					updateProgress(document.getElementById("stamina-bar"),item.outerStamina);
				}

				updateProgress(document.getElementById("hunger-bar"),item.hunger);
				updateProgress(document.getElementById("thirst-bar"),item.thirst);
				
				}
		} else if (item.type === "showAllHUD") {

			if (item.show === true) {
				document.body.style.display = "block";
			} 
		}
	});

	function updateProgress(element, progress, inverse = false) {
		const circle = element.querySelector('.progressCircle');
		if (!circle) {
			console.log('Circle not found');
			return;
		}
	
		const radius = circle.r.baseVal.value;
		const circumference = 2 * Math.PI * radius;
		const fillPercentage = Math.min(Math.max(progress, 0), 100) / 100;
		
		let dashOffset;
		
		if (inverse) {
			dashOffset = circumference * (1 - fillPercentage);
		} else {
			dashOffset = circumference * (1 - fillPercentage);
		}
	
		circle.style.strokeDasharray = `${circumference} ${circumference}`;
		circle.style.strokeDashoffset = dashOffset;

		

	}

	function updateFill(elementId, value) {
		const gradient = document.getElementById(elementId + 'Gradient');
		if (!gradient) return;
		
		const value1 = Math.max(0, Math.min(100, Number(value) || 0));
		const offset = `${100 - value1}%`;
		
		if (gradient.children && gradient.children.length >= 2) {
			gradient.children[0].setAttribute('offset', offset);
			gradient.children[1].setAttribute('offset', offset);
			
			// Change colors to red when value is 0
			const stopColor = value1 <= 20 ? '#4d0202' : '#808080';
			gradient.children[0].setAttribute('stop-color', stopColor);
			gradient.children[1].setAttribute('stop-color', value1 === 0 ? '#ff0000' : '#ffffff');
		}
	}
});
