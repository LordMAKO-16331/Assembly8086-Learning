
#include <stdio.h>

/*
 * 作业题目2：
 * 使用 C 语言打印 ASCII 小写字母
 * 每行 13 个字符，共 2 行
 */
int main(void)
{
    int row;
    int col;

    printf("ascii\n");

    // 外层循环控制两行
    for (row = 0; row < 2; row++)
    {
        // 内层循环控制每行 13 个字母
        for (col = 0; col < 13; col++)
        {
            char ch = (char)('a' + row * 13 + col);
            printf("%c ", ch);
        }

        printf("\n");
    }

    return 0;
}
