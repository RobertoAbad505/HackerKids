import Foundation

struct MyiOSCard {
    //this is a real object structure written in Swift language
    let myName: String = "Roberto Ramirez"
    let phoneNumber = "+52 442 333 0132"
    let location = "Queretaro, Mexico (willing to relocate!)"
    let languages: [String] = ["Spanish", "English"]
    let academicBackground: String = "Bachelor degree in Computer Science"
    
    let extraInfo: String = """
    I am a passionate software developer with international experience, I love to learn new technologies and I am always looking for new challenges.
    """
    //GIT REPOSITORY (Code samples):
    //go visit: https://github.com/RobertoAbad505
    let gitRepository = "https://github.com/RobertoAbad505"
    
    //MY IOS APP:
    //https://github.com/RobertoAbad505/HackerKids
    //This app is currently being review by apple, about to be published at the app store soon.
    //Share your icloud email to get the invite from apple to join the test flight!
    let appStoreSample = "https://github.com/RobertoAbad505/HackerKids"
    
    func letsWorkTogether() -> String {
        return "Let's work together!"
    }
    func writeLocal() {
        let key = "roberto.ramirez.app.storage"
        if let value = UserDefaults.standard.string(forKey: key) {
            var counter = (Int(value) ?? 0) + 1
            UserDefaults.standard.set("\(counter)", forKey: key)
            print("\(counter) memory storage")
            if counter > 5 {
                cleanUserDefaults()
                print("Memory storage cleaned: 0 memory count")
            }
        } else {
            UserDefaults.standard.set("1", forKey: key)
            print("1st memory storage")
        }
    }
    func cleanUserDefaults() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
    }

}
