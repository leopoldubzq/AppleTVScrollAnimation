import Foundation

struct MoviePoster: Hashable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let title: String
    let description: String
    let category: String
    let ageRating: String
    let minimumAge: Int
    let year: Int
    
    init(name: String, title: String, description: String, category: String, ageRating: String, year: Int) {
        self.name = name
        self.title = title
        self.description = description
        self.category = category
        self.ageRating = ageRating
        self.minimumAge = MoviePoster.getMinimumAge(from: ageRating)
        self.year = year
    }
    
    private static func getMinimumAge(from rating: String) -> Int {
        switch rating {
        case "G": return 0
        case "PG": return 7
        case "PG-13": return 13
        case "R": return 17
        case "NC-17": return 18
            
        case "TV-Y": return 0
        case "TV-Y7": return 7
        case "TV-G": return 0
        case "TV-PG": return 7
        case "TV-14": return 14
        case "TV-MA": return 17
            
        default: return 0 // Default value for unknown ratings
        }
    }
}

extension MoviePoster {
    static let mock: [MoviePoster] = [
        MoviePoster(
            name: "severance_poster",
            title: "Severance",
            description: "Employees undergo a procedure to separate work and personal memories.",
            category: "Sci-Fi, Thriller",
            ageRating: "TV-MA",
            year: 2022
        ),
        
        MoviePoster(
            name: "silo_poster",
            title: "Silo",
            description: "In a dystopian future, a community survives in a giant underground silo, uncovering dangerous secrets about their world.",
            category: "Sci-Fi, Mystery, Drama",
            ageRating: "TV-MA",
            year: 2023
        ),
        
        MoviePoster(
            name: "ted_lasso_poster",
            title: "Ted Lasso",
            description: "An American football coach takes on coaching a struggling English soccer team.",
            category: "Comedy, Drama, Sport",
            ageRating: "TV-MA",
            year: 2020
        ),
        
        MoviePoster(
            name: "the_morning_show_poster",
            title: "The Morning Show",
            description: "A behind-the-scenes look at the lives of people working on a morning news show.",
            category: "Drama",
            ageRating: "TV-MA",
            year: 2019
        ),
        
        MoviePoster(
            name: "shrinking_poster",
            title: "Shrinking",
            description: "A grieving therapist starts saying exactly what he thinks to his patients.",
            category: "Comedy, Drama",
            ageRating: "TV-MA",
            year: 2023
        ),
        
        MoviePoster(
            name: "foundation_poster",
            title: "Foundation",
            description: "A grand sci-fi saga about the fall and rebirth of civilizations across the galaxy.",
            category: "Sci-Fi, Drama",
            ageRating: "TV-14",
            year: 2021
        )
    ]
    
    static let mockMovies: [MoviePoster] = [
        MoviePoster(
            name: "finch_poster",
            title: "Finch",
            description: "In a post-apocalyptic world, a robot built to protect the life of his creator's beloved dog learns about life, love, and humanity.",
            category: "Sci-Fi",
            ageRating: "PG-13",
            year: 2021
        ),
        MoviePoster(
            name: "fly_to_the_moon_poster",
            title: "Fly to the Moon",
            description: "An inspiring journey of astronauts determined to reach the moon, facing challenges and discoveries beyond imagination.",
            category: "Adventure",
            ageRating: "PG",
            year: 2024
        ),
        MoviePoster(
            name: "ghosted_poster",
            title: "Ghosted",
            description: "A romantic action-comedy about an ordinary guy who discovers his date is a secret agent, leading to a whirlwind of adventures.",
            category: "Action/Comedy",
            ageRating: "PG-13",
            year: 2023
        ),
        MoviePoster(
            name: "greyhound_poster",
            title: "Greyhound",
            description: "During World War II, a U.S. Navy commander leads an Allied convoy across the treacherous North Atlantic while evading German U-boats.",
            category: "War/Drama",
            ageRating: "PG-13",
            year: 2020
        ),
        MoviePoster(
            name: "killers_of_the_flower_moon_poster",
            title: "Killers of the Flower Moon",
            description: "A gripping true-crime story set in the 1920s, depicting the murders of the Osage people and the birth of the FBI.",
            category: "Crime/Drama",
            ageRating: "R",
            year: 2023
        ),
        MoviePoster(
            name: "luck_poster",
            title: "Luck",
            description: "Follow the unluckiest person in the world as she stumbles upon the Land of Luck and embarks on a magical adventure.",
            category: "Animation/Family",
            ageRating: "G",
            year: 2022
        ),
        MoviePoster(
            name: "napoleon_poster",
            title: "Napoleon",
            description: "A historical epic portraying the rise and fall of Napoleon Bonaparte, exploring his ambitions, battles, and complex personal life.",
            category: "Historical/Drama",
            ageRating: "R",
            year: 2023
        ),
        MoviePoster(
            name: "sharper_poster",
            title: "Sharper",
            description: "A psychological thriller about deception, ambition, and power struggles within New York's billionaire elite.",
            category: "Thriller",
            ageRating: "R",
            year: 2023
        ),
        MoviePoster(
            name: "tetris_poster",
            title: "Tetris",
            description: "The untold story of the legal battle behind the global phenomenon of the Tetris game during the Cold War.",
            category: "Biography/Drama",
            ageRating: "PG-13",
            year: 2023
        ),
        MoviePoster(
            name: "wolfs_poster",
            title: "Wolfs",
            description: "A dark, gripping tale exploring the primal instincts and hidden dangers lurking beneath the surface of human nature.",
            category: "Thriller/Drama",
            ageRating: "R",
            year: 2024
        )
    ]
}
