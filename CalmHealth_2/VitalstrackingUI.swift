import SwiftUI
struct FigmaDesignScreenshot20260416At13849PMPng: View {
	var body: some View {
		VStack(alignment: .leading){
			ScrollView(){
				VStack(alignment: .leading) {
					VStack(alignment: .leading){
						VStack(alignment: .leading, spacing: 0){
							VStack(spacing: 0){
								VStack(alignment: .leading){
									Text("9:41")
										.foregroundColor(Color(hex: "#898785"))
										.font(.system(size: 11))
								}
								.padding(.bottom,32)
								HStack(spacing: 0){
									Text("Vitals Tracking")
										.foregroundColor(Color(hex: "#767573"))
										.font(.system(size: 17))
										.fontWeight(.bold)
									Spacer()
									URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/28aui87t_expires_30_days.png")
										.frame(width : 27, height: 26, alignment: .leading)
								}
								.frame(maxWidth: .infinity)
								.padding(.bottom,15)
								.padding(.horizontal,16)
								VStack(alignment: .trailing){
									HStack(spacing: 0){
										Text("Week")
											.foregroundColor(Color(hex: "#C5C5C5"))
											.font(.system(size: 9))
											.padding(.leading,68)
											.padding(.trailing,61)
										Text("Month")
											.foregroundColor(Color(hex: "#BCBCBC"))
											.font(.system(size: 9))
											.padding(.trailing,35)
									}
									.padding(.vertical,8)
									.background(URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/4v3nywph_expires_30_days.png"))
								}
								.frame(maxWidth: .infinity, alignment: .trailing)
								.overlay(
									Button(action: { print("Pressed!") }){
										VStack(alignment: .leading){
											Text("Day")
												.foregroundColor(Color(hex: "#C0C9C3"))
												.font(.system(size: 10))
												.fontWeight(.bold)
										}
										.padding(.vertical,7)
										.padding(.horizontal,33)
										.background(Color(hex: "#7C8F82"))
										.cornerRadius(9)
										.overlay(RoundedRectangle(cornerRadius: 9)
										.stroke(Color(hex: "#BAC4BD"), lineWidth: 1))
										.padding(.top, 2)
										.padding(.leading, 2)
									}, alignment: .topLeading
								)
								.padding(.bottom,3)
								.padding(.horizontal,17)
							}
							.padding(.top,19)
							.frame(maxWidth: .infinity)
							.padding(.bottom,11)
							.padding(.horizontal,6)
							VStack(alignment: .leading, spacing: 0){
								VStack(alignment: .leading, spacing: 2){
									HStack(spacing: 0){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/lmx1eeev_expires_30_days.png")
											.frame(width : 30, height: 30, alignment: .leading)
											.padding(.trailing,6)
										VStack(alignment: .leading, spacing: 6){
											Text("Blood Pressure")
												.foregroundColor(Color(hex: "#909090"))
												.font(.system(size: 11))
											Text("Last:8:30AM")
												.foregroundColor(Color(hex: "#D2D2D2"))
												.font(.system(size: 9))
										}
										.frame(maxWidth: .infinity, alignment: .leading)
										.padding(.trailing,40)
										Button(action: { print("Pressed!") }){
											VStack(){
												Text("118/76 mmHg")
													.foregroundColor(Color(hex: "#E89898"))
													.font(.system(size: 10))
											}
											.padding(.vertical,7)
											.frame(maxWidth: .infinity)
											.background(Color(hex: "#FCEAEA"))
											.cornerRadius(9)
											.overlay(RoundedRectangle(cornerRadius: 9)
											.stroke(Color(hex: "#FEF5F5"), lineWidth: 1))
										}
									}
									.frame(maxWidth: .infinity)
									.padding(.horizontal,14)
									VStack(alignment: .leading, spacing: 4){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/gr7xs8gp_expires_30_days.png")
											.frame(height: 62)
											.frame(maxWidth: .infinity, alignment: .leading)
											.padding(.horizontal,6)
										HStack(spacing: 0){
											VStack(alignment: .leading){
												Text("M")
													.foregroundColor(Color(hex: "#CFCFCF"))
													.font(.system(size: 9))
											}
											.frame(maxWidth: .infinity, alignment: .leading)
											.padding(.trailing,29)
											Text("T")
												.foregroundColor(Color(hex: "#D3D3D3"))
												.font(.system(size: 7))
												.frame(maxWidth: .infinity, alignment: .center)
												.padding(.trailing,28)
											Text("w")
												.foregroundColor(Color(hex: "#CFCFCF"))
												.font(.system(size: 10))
												.frame(maxWidth: .infinity, alignment: .center)
												.padding(.trailing,27)
											Text("T")
												.foregroundColor(Color(hex: "#EEB4B3"))
												.font(.system(size: 7))
												.frame(maxWidth: .infinity, alignment: .center)
												.padding(.trailing,29)
											VStack(alignment: .leading){
												Text("F")
													.foregroundColor(Color(hex: "#CCCCCD"))
													.font(.system(size: 8))
											}
											.frame(maxWidth: .infinity, alignment: .leading)
											.padding(.trailing,30)
											Text("S")
												.foregroundColor(Color(hex: "#D3D3D3"))
												.font(.system(size: 9))
												.frame(maxWidth: .infinity, alignment: .center)
												.padding(.trailing,28)
											VStack(alignment: .leading){
												Text("S")
													.foregroundColor(Color(hex: "#CDCDCD"))
													.font(.system(size: 9))
											}
											.frame(maxWidth: .infinity, alignment: .leading)
										}
										.frame(maxWidth: .infinity)
										.padding(.horizontal,20)
									}
									.padding(.bottom,5)
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding(.horizontal,8)
								}
								.padding(.vertical,11)
								.frame(maxWidth: .infinity, alignment: .leading)
								.background(Color(hex: "#FFFEFE"))
								.cornerRadius(16)
								.padding(.bottom,12)
								.padding(.horizontal,5)
								HStack(spacing: 10){
									VStack(alignment: .leading, spacing: 0){
										HStack(spacing: 14){
											Text("Temperature")
												.foregroundColor(Color(hex: "#8D8D8D"))
												.font(.system(size: 10))
											URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/0rahgzit_expires_30_days.png")
												.frame(width : 24, height: 24, alignment: .leading)
										}
										.frame(maxWidth: .infinity)
										.padding(.bottom,11)
										.padding(.leading,14)
										Text("36.6C")
											.foregroundColor(Color(hex: "#676868"))
											.font(.system(size: 21))
											.fontWeight(.bold)
											.padding(.bottom,14)
											.padding(.leading,16)
										HStack(spacing: 2){
											URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/7w66u8oq_expires_30_days.png")
												.frame(width : 10, height: 10, alignment: .leading)
											Text("Normal range")
												.foregroundColor(Color(hex: "#B6C2B9"))
												.font(.system(size: 8))
										}
										.padding(.vertical,4)
										.padding(.horizontal,7)
										.background(Color(hex: "#EBF4EE"))
										.cornerRadius(7)
										.overlay(RoundedRectangle(cornerRadius: 7)
										.stroke(Color(hex: "#F6F9F6"), lineWidth: 1))
										.padding(.leading,14)
									}
									.padding(.vertical,14)
									.padding(.trailing,14)
									.frame(maxWidth: .infinity, alignment: .leading)
									.background(Color(hex: "#FFFFFF"))
									.cornerRadius(15)
									VStack(alignment: .leading, spacing: 0){
										HStack(spacing: 0){
											Text("Oxygen")
												.foregroundColor(Color(hex: "#919191"))
												.font(.system(size: 10))
											Spacer()
											URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/wzmxcam3_expires_30_days.png")
												.frame(width : 24, height: 24, alignment: .leading)
										}
										.frame(maxWidth: .infinity)
										.padding(.bottom,10)
										.padding(.leading,14)
										Text("98%")
											.foregroundColor(Color(hex: "#6A6A6A"))
											.font(.system(size: 20))
											.fontWeight(.bold)
											.padding(.bottom,15)
											.padding(.leading,15)
										HStack(spacing: 3){
											URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/elw4qmi2_expires_30_days.png")
												.frame(width : 8, height: 8, alignment: .leading)
											Text("Excellent")
												.foregroundColor(Color(hex: "#BAC6BE"))
												.font(.system(size: 8))
										}
										.padding(.vertical,5)
										.padding(.horizontal,8)
										.background(Color(hex: "#EBF3ED"))
										.cornerRadius(7)
										.overlay(RoundedRectangle(cornerRadius: 7)
										.stroke(Color(hex: "#F5F9F6"), lineWidth: 1))
										.padding(.leading,14)
									}
									.padding(.vertical,13)
									.padding(.trailing,14)
									.frame(maxWidth: .infinity, alignment: .leading)
									.background(Color(hex: "#FEFEFF"))
									.cornerRadius(15)
								}
								.padding(.vertical,3)
								.padding(.horizontal,2)
								.frame(maxWidth: .infinity)
								.padding(.bottom,13)
								.padding(.horizontal,3)
								VStack(alignment: .leading, spacing: 0){
									Text("Forest Breathing Tip")
										.foregroundColor(Color(hex: "#858888"))
										.font(.system(size: 9))
										.padding(.leading,38)
									HStack(spacing: 10){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/qwkv1v98_expires_30_days.png")
											.frame(width : 16, height: 16, alignment: .leading)
										Text("Try 4-7-8 breathing to help lower your blood\npressure naturally.")
											.foregroundColor(Color(hex: "#A6AAAB"))
											.font(.system(size: 8))
											.frame(width : 164, alignment: .leading)
											.fixedSize(horizontal: false, vertical: true)
									}
									.padding(.leading,11)
								}
								.padding(.vertical,13)
								.frame(maxWidth: .infinity, alignment: .leading)
								.background(Color(hex: "#EDF5F7"))
								.cornerRadius(13)
								.overlay(RoundedRectangle(cornerRadius: 13)
								.stroke(Color(hex: "#EBECE9"), lineWidth: 1))
								.padding(.horizontal,6)
							}
							.padding(.vertical,2)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom,113)
							.padding(.horizontal,17)
							VStack(alignment: .trailing){
								HStack(spacing: 0){
									VStack(alignment: .leading, spacing: 2){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/fearx86l_expires_30_days.png")
											.frame(width : 12, height: 13, alignment: .leading)
										Text("VITALS")
											.foregroundColor(Color(hex: "#C5C5C5"))
											.font(.system(size: 8))
									}
									.padding(.trailing,42)
									VStack(alignment: .leading, spacing: 2){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/qkiezoj6_expires_30_days.png")
											.frame(width : 13, height: 13, alignment: .leading)
										Text("MEDS")
											.foregroundColor(Color(hex: "#C1C1C1"))
											.font(.system(size: 7))
									}
									.padding(.trailing,40)
									VStack(alignment: .leading, spacing: 3){
										URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/fl8enjbz_expires_30_days.png")
											.frame(width : 11, height: 11, alignment: .leading)
										Text("A8SIST")
											.foregroundColor(Color(hex: "#C5C5C5"))
											.font(.system(size: 8))
									}
								}
								.padding(.vertical,10)
								.padding(.horizontal,26)
								.background(URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/emimxb6f_expires_30_days.png"))
							}
							.padding(.top,1)
							.padding(.trailing,2)
							.frame(maxWidth: .infinity, alignment: .trailing)
							.overlay(
								VStack(spacing: 2){
									URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/decmoc48_expires_30_days.png")
										.frame(width : 9, height: 11, alignment: .leading)
									Text("HOME")
										.foregroundColor(Color(hex: "#CAD2CC"))
										.font(.system(size: 8))
								}
								.padding(.vertical,5)
								.padding(.horizontal,18)
								.background(URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/jlb5dvg8_expires_30_days.png"))
								.padding(.bottom, 0)
								.padding(.leading, 0), alignment: .bottomLeading
							)
							.padding(.top,1)
							.padding(.bottom,16)
							.padding(.horizontal,27)
						}
						.padding(.top,3)
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(URLImageView(url: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/byLafA9N1m/dyqeik09_expires_30_days.png"))
					}
					.padding(.leading,4)
					.padding(.trailing,16)
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