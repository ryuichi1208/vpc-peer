resource "aws_dynamodb_table" "music" {
  name           = "Music"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Artist"
  range_key      = "SongTitle"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "SongTitle"
    type = "S"
  }
}
