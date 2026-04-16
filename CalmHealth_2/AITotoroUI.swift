import SwiftUI
struct FigmaDesignScreenshot20260416At13918PMPng: View {
	@State private var textField1: String = ""
	@State private var textField2: String = ""
	@State private var textField3: String = ""
	var body: some View {
		VStack(alignment: .leading){
			ScrollView(){
				VStack(alignment: .leading) {
					VStack(alignment: .leading, spacing: 0){
						VStack(alignment: .leading, spacing: 3){
							VStack(alignment: .leading, spacing: 0){
								Text("05 - Al Health Assista...")
									.foregroundColor(Color(hex: "#BCBCBC"))
									.font(.system(size: 24))
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding(.bottom,17)
									.padding(.leading,3)
									.padding(.trailing,29)
								VStack(){
									Text("9:41")
										.foregroundColor(Color(hex: "#73716F"))
										.font(.system(size: 11))
								}
								.padding(.vertical,17)
								.frame(maxWidth: .infinity)
								.background(Color(hex: "#F6F2ED"))
								.border(Color(hex: "#F2F0EE"), width: 4)
								.padding(.bottom,1)
								HStack(spacing: 0){
									URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/8mo79ueh_expires_30_days.png")
										.frame(width : 33, height: 34, alignment: .leading)
										.padding(.leading,16)
										.padding(.trailing,7)
									VStack(alignment: .leading, spacing: 7){
										Text("Totoro Health Assistant")
											.foregroundColor(Color(hex: "#6D6D6D"))
											.font(.system(size: 11))
											.fontWeight(.bold)
										HStack(spacing: 3){
											URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/m3a8a48l_expires_30_days.png")
												.frame(width : 5, height: 5, alignment: .leading)
											Text("Online - Always here for you")
												.foregroundColor(Color(hex: "#C2C2C2"))
												.font(.system(size: 8))
										}
										.padding(.trailing,12)
									}
									Spacer()
								}
								.padding(.vertical,11)
								.frame(maxWidth: .infinity)
								.background(Color(hex: "#FFFFFF"))
								.border(Color(hex: "#F6F6F6"), width: 1)
							}
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.horizontal,5)
							VStack(alignment: .leading, spacing: 0){
								HStack(alignment: .top, spacing: 7){
									URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/s8ae4jsd_expires_30_days.png")
										.frame(width : 24, height: 24, alignment: .leading)
										.padding(.top,65)
									VStack(alignment: .leading, spacing: 6){
										Text("Good morning, Jo! I've\nreviewed your vitals from today. Your\nblood pressure looks great at 118/76.\nHow are you feeling this morning?")
											.foregroundColor(Color(hex: "#AAAAAA"))
											.font(.system(size: 9))
											.frame(width : 161, alignment: .leading)
											.fixedSize(horizontal: false, vertical: true)
										Text("8-20AM")
											.foregroundColor(Color(hex: "#D9D9D9"))
											.font(.system(size: 8))
									}
									.padding(.vertical,11)
									.padding(.leading,10)
									.padding(.trailing,11)
									.background(Color(hex: "#FEFFFF"))
									.cornerRadius(10)
								}
								.padding(.bottom,11)
								.padding(.leading,15)
								VStack(alignment: .trailing){
									VStack(alignment: .leading, spacing: 5){
										Text("l feel a little tired today, and\nmy left knee is a bit sore after\nyesterday's walk,")
											.foregroundColor(Color(hex: "#BAC4BD"))
											.font(.system(size: 9))
											.frame(width : 128, alignment: .leading)
											.fixedSize(horizontal: false, vertical: true)
										Text("8:21AM")
											.foregroundColor(Color(hex: "#A5B9A8"))
											.font(.system(size: 8))
									}
									.padding(.vertical,10)
									.padding(.leading,10)
									.padding(.trailing,21)
									.background(Color(hex: "#738778"))
									.cornerRadius(12)
									.padding(.trailing,18)
								}
								.frame(maxWidth: .infinity, alignment: .trailing)
								.padding(.bottom,12)
								HStack(alignment: .top, spacing: 7){
									URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/fjvaftuf_expires_30_days.png")
										.frame(width : 24, height: 24, alignment: .leading)
										.padding(.top,131)
									VStack(alignment: .leading, spacing: 0){
										Text("I understand, Knee soreness after\nwalking is common, Here are gentle\nsuggestions:")
											.foregroundColor(Color(hex: "#8F8F8F"))
											.font(.system(size: 9))
											.frame(width : 148, alignment: .leading)
											.fixedSize(horizontal: false, vertical: true)
											.padding(.bottom,9)
										TextField("Rest for today, try light stretching", text: $textField1)
											.padding(.vertical,9)
											.padding(.horizontal,8)
											.foregroundColor(Color(hex: "#9DA19E"))
											.font(.system(size: 8))
											.background(Color(hex: "#EBF4EE"))
											.clipRadius(SpecificCornerShape(topLeft: 4, bottomLeft: 7, topRight: 7, bottomRight: 12))
											.padding(.bottom,5)
										TextField("Apply warm compress for 15minutes", text: $textField2)
											.padding(.vertical,7)
											.padding(.horizontal,8)
											.foregroundColor(Color(hex: "#A8A39E"))
											.font(.system(size: 8))
											.background(Color(hex: "#FEF2E8"))
											.cornerRadius(6)
											.padding(.bottom,6)
										Text("8-22AM")
											.foregroundColor(Color(hex: "#D1D1D1"))
											.font(.system(size: 7))
									}
									.padding(.vertical,12)
									.padding(.horizontal,11)
									.background(Color(hex: "#FEFEFE"))
									.cornerRadius(15)
								}
								.padding(.bottom,9)
								.padding(.leading,15)
								HStack(spacing: 0){
									Button(action: { print("Pressed!") }){
										VStack(){
											Text("Check my vitals")
												.foregroundColor(Color(hex: "#B0B0B0"))
												.font(.system(size: 8))
										}
										.padding(.vertical,7)
										.frame(maxWidth: .infinity)
										.background(Color(hex: "#FEFFFE"))
										.cornerRadius(9)
										.padding(.trailing,7)
									}
									Button(action: { print("Pressed!") }){
										VStack(){
											Text("My medications")
												.foregroundColor(Color(hex: "#ABABAB"))
												.font(.system(size: 8))
										}
										.padding(.vertical,7)
										.frame(maxWidth: .infinity)
										.background(Color(hex: "#FEFEFE"))
										.cornerRadius(10)
										.padding(.trailing,8)
									}
									Button(action: { print("Pressed!") }){
										VStack(){
											Text("Wellness tip")
												.foregroundColor(Color(hex: "#A8A8A8"))
												.font(.system(size: 9))
										}
										.padding(.vertical,7)
										.frame(maxWidth: .infinity)
										.background(Color(hex: "#FEFFFE"))
										.cornerRadius(11)
										.overlay(RoundedRectangle(cornerRadius: 11)
										.stroke(Color(hex: "#F3F1ED"), lineWidth: 1))
									}
								}
								.padding(.vertical,2)
								.padding(.horizontal,3)
								.frame(maxWidth: .infinity)
								.padding(.bottom,79)
								.padding(.leading,14)
								.padding(.trailing,25)
							}
							.padding(.top,11)
							.frame(maxWidth: .infinity, alignment: .leading)
							.background(Color(hex: "#F7F3ED"))
							.border(Color(hex: "#EFEEEC"), width: 4)
							.padding(.horizontal,6)
						}
						.padding(.top,5)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom,2)
						.padding(.horizontal,6)
						HStack(alignment: .top, spacing: 6){
							TextField("Ask Totoro anything...", text: $textField3)
								.padding(.vertical,11)
								.padding(.horizontal,10)
								.foregroundColor(Color(hex: "#C7C6C5"))
								.font(.system(size: 10))
								.frame(maxWidth: .infinity, alignment: .leading)
								.background(Color(hex: "#F5F3EE"))
								.cornerRadius(15)
								.overlay(RoundedRectangle(cornerRadius: 15)
								.stroke(Color(hex: "#EDEAE5"), lineWidth: 1))
							URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/qytzeytl_expires_30_days.png")
								.frame(width : 35, height: 34, alignment: .leading)
						}
						.padding(.top,8)
						.padding(.bottom,21)
						.padding(.horizontal,19)
						.frame(maxWidth: .infinity, alignment: .top)
						.background(Color(hex: "#FEFEFE"))
						.border(Color(hex: "#F4F3F1"), width: 1)
						.padding(.bottom,25)
						.padding(.horizontal,9)
					}
					.padding(.top,10)
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(Color(hex: "#EFEFEF"))
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		}
		.padding(.top,0.1)
		.padding(.bottom,0.1)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background(Color(hex: "#FFFFFF"))
	}
}