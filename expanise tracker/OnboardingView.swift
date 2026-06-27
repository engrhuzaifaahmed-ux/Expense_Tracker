import SwiftUI

struct OnboardingView: View {

    @State private var currentPage = 0
    
    let onFinish: () -> Void


    var body: some View {

        VStack {

            TabView(selection: $currentPage) {

                VStack(spacing: 20) {
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Track Expenses")
                        .font(.largeTitle)
                        .bold()

                    Text("Keep track of your daily expenses easily.")
                        .multilineTextAlignment(.center)
                }
                .tag(0)

                VStack(spacing: 20) {
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("View Reports")
                        .font(.largeTitle)
                        .bold()

                    Text("See where your money goes.")
                        .multilineTextAlignment(.center)
                }
                .tag(1)

                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Get Started")
                        .font(.largeTitle)
                        .bold()

                    Text("Let's start managing your expenses.")
                        .multilineTextAlignment(.center)
                }
                .tag(2)
            }
            .tabViewStyle(.page)

            Button {

                if currentPage < 2 {
                    currentPage += 1
                } else {
                    onFinish()
                }

            } label: {

                Text(currentPage == 2 ? "Start" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
