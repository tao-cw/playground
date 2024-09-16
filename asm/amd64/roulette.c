#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

typedef struct list {
    int data;
    struct list* prev;
    struct list* next;
} LIST;

int get_bet() {
    return (int)(rand() * 38.0 / (RAND_MAX + 1.0));
}
int get_amt(LIST* head, LIST* tail) {
    if(head->next == NULL) // head == tail
        return head->data;
    else
        return (head->data + tail->data);
}
LIST* add_to_list( LIST* tail,int data) {
    tail->next = malloc(sizeof(LIST));
    if(tail->next) {
        tail->next->data = data;
        tail->next->next = NULL;
        tail->next->prev = tail;
    }
    return tail->next;
}
void remove_frm_list(LIST** head, LIST** tail) {
    LIST* temp = *head;
    if(*head != *tail) {
        if(*head) {
            *head = (*head)->next;
            if(*head) (*head)->prev = NULL;
            free(temp);
        }
    }
    temp = *tail;
    if(*tail) {
        *tail = (*tail)->prev;
        if(*tail) (*tail)->next = NULL;
        free(temp);
    }
    return;
}
int main() {
    int winnings = 0, chances = 0;
    LIST* head = NULL;
    LIST* tail = NULL;
    LIST* temp;
    head = malloc(sizeof(LIST));
    head->data = 1;
    head->prev = NULL;
    head->next = malloc(sizeof(LIST));
    temp = head->next;
    temp->data = 2;
    temp->prev = head;
    temp->next = malloc(sizeof(LIST));
    temp->next->prev = temp;
    temp->next->data = 3;
    temp->next->next = malloc(sizeof(LIST));
    tail = temp->next->next;
    tail->data = 4;
    tail->prev = temp->next;
    tail->next = NULL;

    srand(getpid() % 1000);
    while(head != NULL && tail != NULL) {
        int temp2 = get_amt(head,tail);
        if(get_bet() < 18) {
            winnings += temp2;
            remove_frm_list(&head,&tail);
        } else {
            winnings -= temp2;
            tail = add_to_list(tail,temp2);
        }
        ++chances;
    }
    printf("RESULTS: %d out of %d tries. %d\n", winnings, chances, getpid());
    return 0;
}

