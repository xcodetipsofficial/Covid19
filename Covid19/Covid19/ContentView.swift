//
//  ContentView.swift
//  Covid19
//
//  Created by Kyle Wilson on 2020-07-13.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var data = getData(country: "canada") //change this for data on different country
    
    var body: some View {
        ZStack {
            
            if self.data.data != nil {
                
                VStack(alignment: .center) {
                    
                    Image(uiImage: getImage(imageString: data.data.countryInfo.flag))
                    Text("Total Cases: \(getValue(data: self.data.data.cases))")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 200, height: 200, alignment: .center)
                        .multilineTextAlignment(.center)
                    Text("Active Cases: \(getValue(data: self.data.data.active))")
                        .font(.headline)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.red)
                        .padding(20)
                    Text("Recovered: \(getValue(data: self.data.data.recovered))")
                        .font(.headline)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.green)
                }
                
            } else {
                GeometryReader { geo in
                    VStack {
                        Indicator()
                    }
                }
            }
            
            
        }
    }
}

struct Indicator: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getValue(data: Double) -> String {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    
    return format.string(from: NSNumber(value: data))!
}

func getImage(imageString: String) -> UIImage {
    let imageURL = URL(string: imageString)
    let imageData = try! Data(contentsOf: imageURL!)
    let image = UIImage(data: imageData)
    return image!
}


class getData: ObservableObject {
    
    @Published var data: Country!
    
    init(country: String) {
        updateData(country: country)
    }
    
    func updateData(country: String) {
        let url = "https://corona.lmao.ninja/v3/covid-19/countries/\(country)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            let json = try! JSONDecoder().decode(Country.self, from: data!)
            
            DispatchQueue.main.async {
                self.data = json
            }
        }.resume()
    }
}
