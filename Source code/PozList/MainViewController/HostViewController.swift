//
// HostViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import AKSideMenu

/*
HostViewController is container view controller, contains menu controller and the list of relevant view controllers.

Responsible for creating and selecting menu items content controlers.
Has opportunity to show/hide side menu.
*/
class HostViewController: AKSideMenu,AKSideMenuDelegate {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.menuPreferredStatusBarStyle = .lightContent
		self.contentViewShadowColor = .blue
		self.contentViewShadowOffset = CGSize(width: 10, height: 10)
		self.contentViewShadowOpacity = 0.6
		self.contentViewShadowRadius = 0.0
		self.contentViewShadowEnabled = true
		
		let userType = UserDefaults.Main.string(forKey: .Appuser)
		self.contentViewController = userType == "Service"
			? storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "serviceProvCantaintView")
			: storyBoards.Customer.instantiateViewController(withIdentifier: "customerCantaintView")
		//		if userType == "Service"{
		//			storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "serviceProvCantaintView")
		//		} else {
		//			self.contentViewController = storyBoards.Customer.instantiateViewController(withIdentifier: "customerCantaintView")
		//		}
		self.leftMenuViewController = storyBoards.Customer.instantiateViewController(withIdentifier: "NavigationMenu")
		//self.backgroundImage = UIImage(named: "Stars")
		self.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
