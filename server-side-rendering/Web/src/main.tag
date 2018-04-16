<blog>

  <post each={ posts }>
    <button onclick={ this.parent.deletePost }>delete</button>
  </post>

  <script>
    this.posts = opts.posts || [
      { id: 0, title: "title 1", description: 'hardcoded js post description' },
      { id: 1, title: "title 2", description: 'hardcoded js post description' }
    ]
    this.error = ""

    this.deletePost = (e) => {
      this.posts = this.posts.filter(p => p.id !== e.item.id)
      this.update()
    }

    this.ready = () => {
      this.trigger('ready')
    }

    fetch('/article')
      .then((response) => response.json() )
      .then((data) => {
        this.posts = data
        this.update()
        this.ready()
      })
      .catch((err) => {
        console.log(err)
        this.ready()
      })

  </script>
</blog>

<post>
  <h2>{ title }</h2>
  <p>{ description }</p>
  <yield/>
</post>
