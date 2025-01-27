.model small
.stack 100h
.data
    menu db "1. Search for a Song", 0Dh, 0Ah
         db "2. Request a Song", 0Dh, 0Ah
         db "3. Add/Sub a Song", 0Dh, 0Ah
         db "4. Enqueue/Dequeue a Song", 0Dh, 0Ah
         db "5. Play a Song", 0Dh, 0Ah
         db "6. View Playlist", 0Dh, 0Ah
         db "7. Exit", 0Dh, 0Ah
         db "Enter your choice: $"

    invalid_choice db "Invalid choice! Please try again.$", 0
    search_prompt db "Enter the name of the song to search: $"
    search_result db "Song not found!$", 0
    add_prompt db "Enter the name of the song to ADD: $"
    sub_prompt db "Enter the name of the song to REMOVE: $"
    enqueue_prompt db "Enter the name of the song to ENQUEUE: $"
    dequeue_result db "Dequeued song: $"
    empty_playlist db "Playlist is empty!$", 0
    play_prompt db "Enter the name of the song to PLAY: $"
    playlist_msg db "Current Playlist:$"
    song_found db "Song found: $"

    songs db "Song1", 0, "Song2", 0, "Song3", 0, "Song4", 0
         db "Song5", 0, "Song6", 0, "Song7", 0, "Song8", 0
         db "Song9", 0, "Song10", 0

    playlist db "Song1", 0, "Song3", 0, "Song5", 0, "Song7", 0, 0

    newline db 0Dh, 0Ah, '$'
    input_buffer db 20 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

main_menu:; Display menu and get choice
    mov dx, offset menu
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    jl invalid_input
    cmp al, 7
    jg invalid_input; Navigate to choice
    cmp al, 1
    je search_song
    cmp al, 2
    je request_song
    cmp al, 3
    je add_or_sub_song
    cmp al, 4
    je enqueue_dequeue_song
    cmp al, 5
    je play_song
    cmp al, 6
    je view_playlist
    cmp al, 7
    je exit_program

invalid_input:
    mov dx, offset invalid_choice
    mov ah, 09h
    int 21h
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

search_song:; Search for a song
    mov dx, offset search_prompt
    mov ah, 09h
    int 21h
    call take_input
    lea si, songs
search_loop:
    lodsb
    cmp al, 0
    je not_found
    mov di, offset input_buffer + 1
    mov cl, input_buffer[0]
    repe cmpsb
    je found
    jmp search_loop

not_found:
    mov dx, offset search_result
    mov ah, 09h
    int 21h
    jmp main_menu

found:
    mov dx, offset song_found
    mov ah, 09h
    int 21h
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

request_song:; Request a song
    mov dx, offset search_prompt
    mov ah, 09h
    int 21h
    call take_input
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

add_or_sub_song:; Add/Sub a song
    mov dx, offset add_prompt
    mov ah, 09h
    int 21h
    call take_input
    lea di, playlist
find_end_of_playlist:
    lodsb
    cmp al, 0
    je add_song_to_end
    jmp find_end_of_playlist

add_song_to_end:
    lea si, input_buffer + 1
copy_song:
    lodsb
    stosb
    cmp al, 0
    jne copy_song

    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

enqueue_dequeue_song:; Enqueue/Dequeue a song
    mov dx, offset enqueue_prompt
    mov ah, 09h
    int 21h
    call take_input
    lea di, playlist
enqueue_add:
    lodsb
    cmp al, 0
    je enqueue_to_end
    jmp enqueue_add

enqueue_to_end:
    lea si, input_buffer + 1
enqueue_copy:
    lodsb
    stosb
    cmp al, 0
    jne enqueue_copy
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

play_song:; Play a song
    mov dx, offset play_prompt
    mov ah, 09h
    int 21h
    call take_input
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

view_playlist:; View the playlist
    mov dx, offset playlist_msg
    mov ah, 09h
    int 21h
    lea si, playlist
display_playlist:
    lodsb
    cmp al, 0
    je end_playlist
    mov dl, al
    mov ah, 02h
    int 21h
    jmp display_playlist
end_playlist:
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp main_menu

exit_program:; Exit program
    mov dx, offset newline
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h

take_input proc
    lea dx, input_buffer
    mov ah, 0Ah
    int 21h
    ret
take_input endp
end main
