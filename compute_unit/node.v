module node (
    input wire clk,
    input wire rst,
    input wire preset_ext,
    input wire[3:0] en_from,
    input wire[3:0] ready_from,
    input wire[3:0] exist_from,
    input wire[15:0] value_from,
    input wire[3:0] value_from_preset,
    output wire[3:0] current_value,
    output wire[3:0] en_to,
    output wire[3:0] ready_to,
    output wire[3:0] exist_to
);

    parameter idle = 0, ready = 1, pending = 2, ended = 3;

    reg broadcast_en; // en_from을 그대로 넘길지 현재 node에서 en 신호를 broacast할지 결정
    reg mode; // 0이면 preset 설정, 1이면 +1
    reg[3:0] direction; // dataflow 방향 저장
    reg[1:0] state, next_state; // 현재 상태와 이후 상태
    reg preserve; // 현재 상태 유지

    wire[3:0] neighbor; // dataflow 방향에 맞는 인접 value
    wire[3:0] candidate; // enable 신호에 맞는 인접 value
    wire[3:0] shift_input_value = preset_ext ? value_from_preset : candidate; // shift register에 들어갈 value

    // broadcast 설정 시 direction 대로 enable 전송, 그렇지 않다면 en_from 그대로 전송
    assign en_to = broadcast_en ? direction : en_from;

    // 현재 node의 value가 0이 아니라면 exist를 모두 1로 set. 그렇지 않다면 그대로 전송
    assign exist_to = current_value != 4'b0000 ? 4'b1111 : exist_from;

    // 현재 node의 값을 저장하는 shift register
    shift_register current_value_module(
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .preset(preset_ext),
        .en_from(en_to && ~preserve),
        .value_from(shift_input_value),
        .current_value(current_value)
    );

    // en_to의 방향에 맞는 value를 추출하는 mux
    direction_value_mux mux_1(
        .signal_from(en_to),
        .value_from(value_from),
        .out(candidate)
    );

    // direction의 방향에 맞는 value를 추출하는 mux
    direction_value_mux mux_2(
        .signal_from(direction),
        .value_from(value_from),
        .out(neighbor)
    );

    // 상태 전이
    always @ (posedge clk) begin
        if (rst == 1'b0) state <= idle;
        else state <= next_state;
    end

    // 다음 상태 결정
    always @ (state or ready_from or current_value or direction or exist_from or neighbor) begin
        if (state == idle) begin
            if (ready_from != 4'b0000) begin // ready_from이 입력된다면
                next_state <= ready;
            end
            else begin
                next_state <= idle;
            end
        end
        else if (state == ready) begin
            if (current_value == 4'b0000 && (direction & exist_from) != 4'b0000) begin // 현재 칸이 비어있고 남은 칸이 비어있지 않은 경우
                next_state <= pending;
            end
            else if (current_value != 4'b0000 && current_value == neighbor) begin // 현재 칸과 옆 칸의 값이 동일할 경우
                next_state <= ended;
            end else if ((neighbor == 4'b0000 && (direction & exist_from) != 4'b0000)) begin // 옆 칸이 비고 dataflow에 블럭이 존재하는 경우
                next_state <= pending;
            end
            else begin // 밀리지 않는 경우
                next_state <= ended; // ended state로 회귀
            end
        end
        else if (state == pending) begin
            next_state <= ready;
        end
        else begin
            next_state <= idle;
        end
    end

    // broadcast_en / preserve 결정
    always @ (current_value or direction or exist_from or neighbor or state) begin
        if (state == ready && // 현재 상태가 ready이며
            ((current_value == 4'b0000 && (direction & exist_from != 4'b0000)) || // 현재 칸이 비어있으며 뒤이은 칸에 블럭이 존재하거나
            (current_value != 4'b0000 && current_value == neighbor))) begin // 현재 칸의 값이 이웃한 칸의 값과 같거나
                broadcast_en <= 1'b1; // enable 신호를 broadcast
                preserve <= 1'b0;
        end
        else if (state == ready && (neighbor == 4'b0000 && (direction & exist_from) != 4'b0000)) begin // 옆 칸이 비어있고 dataflow에 블럭이 존재한다면
            broadcast_en <= 1'b1;
            preserve <= 1'b1;
        end
        else begin
            broadcast_en <= 1'b0;
            preserve <= 1'b0;
        end
    end

    // ready_to 결정
    assign ready_to = state == ended ? direction : 4'b0000;

    // mode 결정
    always @ (state or current_value or neighbor) begin
        if (state == ready && current_value == neighbor) mode <= 1'b1;
        else mode <= 1'b0;
    end

    // direction 결정
    always @ (posedge clk) begin
        if (state == idle && ready_from != 4'b0000) direction <= ready_from;
        else if (state != idle) direction <= direction;
        else direction <= 4'b0000;
    end
    
endmodule