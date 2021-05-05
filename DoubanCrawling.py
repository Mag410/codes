import expanddouban
import urllib
from bs4 import BeautifulSoup
import csv


# 任务1构建URL
def getMovieUrl(category, location):
    return "https://movie.douban.com/tag/#/?sort=T&range=9,10&tags=电影,{},{}".format(category, location)


# 任务2代码
def getHtml(url):
    return expanddouban.getHtml(url, loadmore=True)


# 任务3构建电影类
class Movie:
    def __init__(self, name, rate, location, category, info_link, cover_link):
        self.name = name
        self.rate = rate
        self.location = location
        self.category = category
        self.info_link = info_link
        self.cover_link = cover_link

    def movie_info(self):
        return self.name, self.rate, self.location, self.category, self.info_link, self.cover_link


# 任务4获得豆瓣电影信息
def getMovies(category, location):
    url = getMovieUrl(category, location)
    html_doc = getHtml(url)
    soup = BeautifulSoup(html_doc, 'html.parser')
    items = soup.find_all('a', 'item')
    movies = []
    for item in items:
        name = item.find('span', 'title').string
        rate = item.find('span', 'rate').string
        info_link = item['href']
        cover_link = item.find('img')['src']
        a = Movie(name, rate, location, category, info_link, cover_link)
        b = a.movie_info()
        movies.append(b)
    return movies


# print(getMovies('科幻','美国'))


# 任务5构造电影数据表
import codecs
with codecs.open("movies.csv", "w", 'utf_8_sig') as f:
        categories = [ '动作', '青春', '励志']
        locations = ["大陆", "美国", "香港", "台湾", "日本", "韩国", "英国", "法国", "德国", "意大利", '西班牙',
                     "印度", "泰国", "俄罗斯", "伊朗", "加拿大", "澳大利亚", "爱尔兰", "瑞典", "巴西", "丹麦"]
        movies = []
        for c in categories:
            for l in locations:
                movies += getMovies(c, l)
            moviewriter = csv.writer(f, dialect='excel')
            for movie in movies:
                moviewriter.writerow(movie)


# 任务六统计每个类型，每个类型电影排名前三地区，分别计算此类别电影占总数的百分比
def get_Movies_Percentage():
    with open('output.txt', 'w', encoding='utf-8') as f:
        with open('movies.csv', 'r', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile)
            texts = list(reader)
        categories = set([i[3] for i in texts])
        location = set([z[2] for z in texts])
        for c in categories:
            movies_in_c = [m for m in texts if m[3] == c]
            count_by_location = []
            for l in location:
                count_by_location.append((l, len([m for m in movies_in_c if m[2] == l])))
            sorted_list = sorted(count_by_location, key=lambda x: x[1], reverse=True)
            first_location, first_count = sorted_list[0]
            second_location, second_count = sorted_list[1]
            third_location, third_count = sorted_list[2]
            total = len(movies_in_c)
            f.write('豆瓣共收录{}片 {} 部，数量排名前三的地区为{}、{}、{}，依次占比 {:.2%}、{:.2%}、{:.2%}。\n'.format(
                c, total, first_location, second_location, third_location,
                first_count / total, second_count / total, third_count / total))


if __name__ == '__main__':
    #main()
    get_Movies_Percentage()