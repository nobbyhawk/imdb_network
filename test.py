from imdb import IMDb

actors = list()
movies = list()


ia = IMDb()
the_matrix = ia.get_movie('0133093')

for person in the_matrix["cast"]:
    actors.append(person)

# Now find a person's movies
#for actor in actors[0:2]:
#print(actor['name'])
#for movie in ia.get_person(actor.personID)['filmography'][0]['actor']:
# movies.append(movie.movieID)

def get_movies_from_actor(actor):
    all_movies = list()

    person = ia.get_person(actor.personID)['filmography'][0]
    if 'actor' not in person:
        return

    for movie in person['actor']:
        all_movies.append(movie)

    return all_movies

for actor in actors:
    print(actor)
    new_movies = get_movies_from_actor(actor)
    if new_movies is not None:
        movies += new_movies


print("Number of movies:", len(movies))
print("Number of actors:", len(actors))