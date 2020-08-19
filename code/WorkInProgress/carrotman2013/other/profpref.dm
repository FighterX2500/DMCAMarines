//Job names for lobby proc. Written by Carrotman2013.

//Если на "High" стоит какая-то профессия - будет название, иначе - ничего.
datum/preferences
	proc/update_future_job()
		if(updating_future_job)
			return
		updating_future_job = 1
		if(job_marines_high)
			switch(job_marines_high)
				if(ROLE_MARINE_STANDARD)
					choosen_job = "Squad Marine"

				if(ROLE_MARINE_ENGINEER)
					choosen_job = "Squad Engineer"

				if(ROLE_MARINE_LEADER)
					choosen_job = "Squad Leader"

				if(ROLE_MARINE_MEDIC)
					choosen_job = "Squad Medic"

				if(ROLE_MARINE_SPECIALIST)
					choosen_job = "Squad Specialist"

				if(ROLE_MARINE_SMARTGUN)
					choosen_job = "Squad Smartgunner"

		else if(job_command_high)
			switch(job_command_high)
				if(ROLE_COMMANDING_OFFICER)
					choosen_job = "Commander"

				if(ROLE_BRIDGE_OFFICER)
					choosen_job = "Staff Officer"

				if(ROLE_EXECUTIVE_OFFICER)
					choosen_job = "Executive Officer"

				if(ROLE_PILOT_OFFICER)
					choosen_job = "Pilot Officer"

				if(ROLE_CORPORATE_LIAISON)
					choosen_job = "Corporate Liaison"

				if(ROLE_SYNTHETIC)
					choosen_job = "Synthetic"

				if(ROLE_MILITARY_POLICE)
					choosen_job = "Military Police"

				if(ROLE_CHIEF_MP)
					choosen_job = "Chief MP"

				if(ROLE_TANK_OFFICER)
					choosen_job = "Tank Crewman"

				if(ROLE_MECH_PILOT)
					choosen_job = "Mech Operator"

		else if(job_logistics_high)
			switch(job_logistics_high)
				if(ROLE_LOGISTICS_OFFICER)
					choosen_job = "Logistics Officer"

				if(ROLE_SUPPLY_AND_MAINT_TECH)
					choosen_job = "Supply And Maintenance Tech"

//				if(ROLE_REQUISITION_OFFICER)
//					choosen_job = "Requisitions Officer"
//
//				if(ROLE_REQUISITION_TECH)
//					choosen_job = "Cargo Technician"

		else if(job_medsci_high)
			switch(job_medsci_high)
				if(ROLE_CHIEF_MEDICAL_OFFICER)
					choosen_job = "CMO"

				if(ROLE_CIVILIAN_DOCTOR)
					choosen_job ="Doctor"

				if(ROLE_CIVILIAN_RESEARCHER)
					choosen_job = "Researcher"

		else
			choosen_job = 0

		updating_future_job = 0